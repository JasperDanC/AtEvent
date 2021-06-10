import 'package:at_event/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child:
                        Image.asset('assets/images/People_on_seafront_15.jpg'),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Some people look for a beautiful place. Others make a place beautiful.\n-Hazrat Inavat Khan",
                    style: kQuoteTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
