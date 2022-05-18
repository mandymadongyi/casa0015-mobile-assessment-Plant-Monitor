import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Pagemsm extends StatefulWidget {
  const Pagemsm({Key? key}) : super(key: key);

  @override
  State<Pagemsm> createState() => _PagemsmState();
}

class _PagemsmState extends State<Pagemsm> {
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
                Fixeducfnmsm(),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: PlantView(),
                )
              ],
            )));
  }
}

class Fixeducfnmsm extends StatelessWidget {
  const Fixeducfnmsm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 40.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('image/PlantMSM.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 100.0),
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Plant Name: Roise',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'ID: ucfnmsm',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Owner: Abi Choi',
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
  String? Temperaturemsm;
  String? Humiditymsm;
  String? Moisturemsm;

  final client = MqttServerClient('mqtt.cetools.org', 'mandymadongyimsm');

  @override
  void initState() {
    super.initState();

    Temperaturemsm = "wait a second";
    Humiditymsm = "wait...";
    Moisturemsm = "wait!!";

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
          'Temperature: $Temperaturemsm',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Humidity: $Humiditymsm',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Moisture: $Moisturemsm',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ],
    ));
  }

  updateList(String s, int i) {
    setState(() {
      if (i == 0) {
        Temperaturemsm = s;
      }
      if (i == 1) {
        Humiditymsm = s;
      }
      if (i == 2) {
        Moisturemsm = s;
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
    const topic1 = 'student/CASA0014/plant/ucfnmsm/temperature';
    client.subscribe(topic1, MqttQos.atMostOnce);
    const topic2 = 'student/CASA0014/plant/ucfnmsm/humidity';
    client.subscribe(topic2, MqttQos.atMostOnce);
    const topic3 = 'student/CASA0014/plant/ucfnmsm/moisture';
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
