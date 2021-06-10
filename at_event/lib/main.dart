import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/screens/WelcomeScreen.dart';

void main() => runApp(Vento());

class Vento extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: kForegroundGrey,
          scaffoldBackgroundColor: kBackgroundGrey),
      home: Scaffold(
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
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: WelcomeScreen(),
      ),
    );
  }
}
