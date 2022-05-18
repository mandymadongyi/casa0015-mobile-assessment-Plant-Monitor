import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Pagecku extends StatefulWidget {
  const Pagecku({Key? key}) : super(key: key);

  @override
  State<Pagecku> createState() => _PageckuState();
}

class _PageckuState extends State<Pagecku> {
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
                Fixeducfncku(),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: PlantViewcku(),
                )
              ],
            )));
  }
}

class Fixeducfncku extends StatelessWidget {
  const Fixeducfncku({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 40.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('image/PlantCKU.jpg'),
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
                    'ID: ucfncku',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Owner: Vivian',
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

class PlantViewcku extends StatefulWidget {
  @override
  PlantViewckuState createState() {
    return PlantViewckuState();
  }
}

class PlantViewckuState extends State<PlantViewcku> {
  String? Temperaturecku;
  String? Humiditycku;
  String? Moisturecku;

  final client = MqttServerClient('mqtt.cetools.org', 'mandymadongyicku');

  @override
  void initState() {
    super.initState();

    Temperaturecku = "wait a second";
    Humiditycku = "wait...";
    Moisturecku = "wait!!";

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
          'Temperature: $Temperaturecku',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Humidity: $Humiditycku',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Moisture: $Moisturecku',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ],
    ));
  }

  updateList(String s, int i) {
    setState(() {
      if (i == 0) {
        Temperaturecku = s;
      }
      if (i == 1) {
        Humiditycku = s;
      }
      if (i == 2) {
        Moisturecku = s;
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
    const topic1 = 'student/CASA0014/plant/ucfncku/temperature';
    client.subscribe(topic1, MqttQos.atMostOnce);
    const topic2 = 'student/CASA0014/plant/ucfncku/humidity';
    client.subscribe(topic2, MqttQos.atMostOnce);
    const topic3 = 'student/CASA0014/plant/ucfncku/moisture';
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
