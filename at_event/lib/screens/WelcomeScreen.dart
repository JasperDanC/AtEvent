import 'package:at_event/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/Widgets/reusable_widgets.dart';
import 'package:at_event/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Stack(
          children: <Widget>[
            Pinned.fromPins(
              Pin(start: 12.0, end: 12.0),
              Pin(size: 600.0, end: 39.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, 1.0),
                    colors: [const Color(0xffc5cdfb), const Color(0xff20295b)],
                    stops: [0.0, 1.0],
                  ),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
            Pinned.fromPins(
              // Cover image
              Pin(start: 12.0, end: 12.0),
              Pin(size: 308.0, middle: 0.3),
              child:
                  // Adobe XD layer: 'People_on_seafront_…' (shape)
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
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
            Pinned.fromPins(
              Pin(start: 34.0, end: 33.0),
              Pin(size: 138.0, middle: 0.75),
              child: Text(
                '"Some people look for a beautiful place. Others make a place beautiful.”\n-Hazrat Inavat Khan',
                style: kQuoteTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            StartRoundButton(position: 0.8, text: 'Getting Started')
          ],
        ),
      ),
    );
  }
}
