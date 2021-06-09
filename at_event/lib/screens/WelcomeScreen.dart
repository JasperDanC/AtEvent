import 'package:at_event/constants.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [
                  const Color(0xff171616),
                  const Color(0xff1b1a1a),
                  const Color(0xff727272),
                  const Color(0xff808080)
                ],
                stops: [0.0, 0.0, 0.46, 1.0],
              ),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 100.0, start: 12.0),
            Pin(size: 95.0, start: 75.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/atsign.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 12.0, end: 12.0),
            Pin(size: 549.0, end: 39.0),
            child: Container(
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
            ),
          ),
          Pinned.fromPins(
            Pin(size: 206.0, middle: 0.5825),
            Pin(size: 78.0, start: 92.0),
            child: Flexible(
              child: Text(
                'Vento',
                style: kTitleTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 12.0, end: 12.0),
            Pin(size: 308.0, middle: 0.4),
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
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 34.0, end: 33.0),
            Pin(size: 138.0, middle: 0.8),
            child: Text(
              '"Some people look for a beautiful place. Others make a place beautiful.”\n-Hazrat Inavat Khan',
              style: kQuoteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 60.0, end: 59.0),
            Pin(size: 56.0, middle: 0.89),
            child: MaterialButton(
              elevation: 10.0,
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: kPrimaryBlue,
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 156.0, middle: 0.5),
            Pin(size: 29.0, middle: 0.88),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 156.0,
                height: 30.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(start: -1.0, end: 0.0),
                      child: Text(
                        'Getting Started',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: const Color(0xfff1f1f1),
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
