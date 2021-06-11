import 'package:at_event/screens/calendar_screen.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:at_event/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/screens/WelcomeScreen.dart';
import 'package:flutter/services.dart';
import 'package:at_event/models/event.dart';

void main() async {
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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => WelcomeScreen(),
        '/HomeScreen': (BuildContext context) => HomeScreen(),
        '/CalendarScreen': (BuildContext context) => CalendarScreen(),
      }
    );
  }
}
