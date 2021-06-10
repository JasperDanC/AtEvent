import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(45.0),
          bottomLeft: Radius.circular(45.0),
        )),
        centerTitle: true,
        backgroundColor: kPrimaryBlue,
        title: Text(
          "@Vento",
          style: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Background(),
          ],
        ),
      ),
    );
  }
}
