import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/screens/WelcomeScreen.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:at_event/models/event.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(Vento());
}

class Vento extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: kForegroundGrey,
          scaffoldBackgroundColor: kBackgroundGrey),
      home: WelcomeScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => HomeScreen()
      },
    );
  }
}
