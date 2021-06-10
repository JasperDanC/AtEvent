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
      home: WelcomeScreen(),

    );
  }
}
