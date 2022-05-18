import 'package:flutter/material.dart';
import 'ucfnmsm.dart';
import 'ucfnaka.dart';
import 'ucfnxxx.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Plant Monitor",
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new FirstRoute(),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 70.0),
                  child: Text('Select the plant you want to browse',
                      style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Namelist(),
                ),
                Notification(),
              ],
            )));
  }
}

class Namelist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Column(children: [
          ElevatedButton(
            child: Text('ucfnmsm'),
            onPressed: () {
              _NotificationState.client.disconnect();
              print('client disconnected');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SecondRoute();
              }));
            },
          ),
          ElevatedButton(
            child: Text('ucfnaka'),
            onPressed: () {
              _NotificationState.client.disconnect();
              print('client disconnected');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ThirdRoute();
              }));
            },
          ),
          ElevatedButton(
            child: Text('ucfnxxx'),
            onPressed: () {
              _NotificationState.client.disconnect();
              print('client disconnected');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FourthRoute();
              }));
            },
          )
        ]),
      ]),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  String MSM = '0';
  String AKA = '0';
  String XXX = '0';
  int msm = 101;
  int aka = 101;
  int xxx = 101;

  static final client =
      MqttServerClient('mqtt.cetools.org', 'mandymadongyihome');

  @override
  void initState() {
    super.initState();

    startMQTT();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    client.disconnect();
    print('client disconnected');
    super.dispose();
  }

  updateList(String s, int i) {
    setState(() {
      if (i == 0) {
        MSM = s;
      }
      if (i == 1) {
        AKA = s;
      }
      if (i == 2) {
        XXX = s;
      }

      msm = int.parse(MSM);
      aka = int.parse(AKA);
      xxx = int.parse(XXX);

      print('msm=');
      print(msm);

      print('aka=');
      print(aka);

      print('xxx=');
      print(xxx);
    });
  }

  Future<void> startMQTT() async {
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 10;
    const String username = 'student';
    const String password = 'ce2021-mqtt-forget-whale';
    try {
      await client.connect(username, password);
    } catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    const topic1 = 'student/CASA0014/plant/ucfnmsm/moisture';
    client.subscribe(topic1, MqttQos.atMostOnce);
    const topic2 = 'student/CASA0014/plant/ucfnaka/moisture';
    client.subscribe(topic2, MqttQos.atMostOnce);
    const topic3 = 'student/CASA0014/plant/ucfnxxx/moisture';
    client.subscribe(topic3, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      if (c[0].topic == topic1) {
        updateList(messageString, 0);
      }
      if (c[0].topic == topic2) {
        updateList(messageString, 1);
      }
      if (c[0].topic == topic3) {
        updateList(messageString, 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 230.0, top: 100),
          child: Text(
            'Notification',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 30),
          child: Text(
            'Wanna know which plant needs watering?',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 32, top: 30),
          child: Text(
            'Wait for moisture level from mqtt...',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        if (msm < 100)
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 30),
            child: Text(
              'Please water ucfnmsm!!!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        if (aka < 100)
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20),
            child: Text(
              'Please water ucfnaka!!!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        if (xxx < 100)
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20),
            child: Text(
              'Please water ucfnxxx!!!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
      ],
    ));
  }
}
