import 'package:flutter/material.dart';
import 'ucfnmsm.dart';
import 'ucfnaka.dart';
import 'ucfnxxx.dart';

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
                  padding: const EdgeInsets.only(left: 70.0, top: 70.0),
                  child: Text('Select the plant you want to browse',
                      style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                  child: namelist(),
                ),
                notification(),
              ],
            )));
  }
}

class namelist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            ElevatedButton(
              child: Text('ucfnmsm'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SecondRoute();
                }));
              },
            ),
            ElevatedButton(
              child: Text('ucfnaka'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ThirdRoute();
                }));
              },
            ),
            ElevatedButton(
              child: Text('ucfnxxx'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FourthRoute();
                }));
              },
            )
          ]),
        )
      ]),
    );
  }
}

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 170.0, top: 100),
          child: Text(
            'Notification',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 30),
          child: Text(
            '1. Please water ucfnmsm!!!',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text(
            '2. Please water ucfnaka!!!',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text(
            '3. Please water ucfnxxx!!!',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ],
    ));
  }
}
