import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class FourthRoute extends StatefulWidget {
  const FourthRoute({Key? key}) : super(key: key);

  @override
  State<FourthRoute> createState() => _FourthRouteState();
}

class _FourthRouteState extends State<FourthRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plant info'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              children: [
                fixeducfnxxx(),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: PlantView(),
                )
              ],
            )));
  }
}

class fixeducfnxxx extends StatelessWidget {
  const fixeducfnxxx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 40.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('image/PlantXXX.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 100.0),
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Plant Name: Robin',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'ID: ucfnxxx',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Owner: Duncan Wilson',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PlantView extends StatefulWidget {
  @override
  PlantViewState createState() {
    return PlantViewState();
  }
}

class PlantViewState extends State<PlantView> {
  String? Temperaturexxx;
  String? Humidityxxx;
  String? Moisturexxx;

  final client = MqttServerClient('mqtt.cetools.org', 'mandymadongyixxx');

  @override
  void initState() {
    super.initState();

    Temperaturexxx = "wait a second";
    Humidityxxx = "wait...";
    Moisturexxx = "wait!!";

    startMQTT();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    client.disconnect();
    print('client disconnected');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Temperature: $Temperaturexxx',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Humidity: $Humidityxxx',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Moisture: $Moisturexxx',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ],
    ));
  }

  updateList(String s, int i) {
    setState(() {
      if (i == 0) {
        Temperaturexxx = s;
      }
      if (i == 1) {
        Humidityxxx = s;
      }
      if (i == 2) {
        Moisturexxx = s;
      }
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
    const topic1 = 'student/CASA0014/plant/ucfnxxx/temperature';
    client.subscribe(topic1, MqttQos.atMostOnce);
    const topic2 = 'student/CASA0014/plant/ucfnxxx/humidity';
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
}
