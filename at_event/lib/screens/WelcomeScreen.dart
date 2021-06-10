import 'package:at_event/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/Widgets/reusable_widgets.dart';
import 'package:at_event/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: const AssetImage(
                      'assets/images/People_on_seafront_15.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Intro Text
/*
Text(
'"Some people look for a beautiful place. Others make a place beautiful.”\n-Hazrat Inavat Khan',
style: kQuoteTextStyle,
textAlign: TextAlign.center,
),*/

// Intro Image

/*Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.only(
topLeft: Radius.circular(20.0),
topRight: Radius.circular(20.0),
),
image: DecorationImage(
image: const AssetImage(
'assets/images/People_on_seafront_15.jpg'),
fit: BoxFit.cover,
),
border: Border.all(width: 1.0, color: const Color(0xff707070)),
),
),*/

// Box
/*  Container(
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  gradient: LinearGradient(
  begin: Alignment(0.0, -1.0),
  end: Alignment(0.0, 1.0),
  colors: [const Color(0xffc5cdfb), const Color(0xff20295b)],
  stops: [0.0, 1.0],
  ),
  border: Border.all(width: 1.0, color: const Color(0xff707070)),
  ),
  ),*/
}
