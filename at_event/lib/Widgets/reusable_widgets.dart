import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/constants.dart';

class StartRoundButton extends StatefulWidget {
  final position;
  final String text;
  StartRoundButton({@required this.position, @required this.text});

  @override
  _StartRoundButtonState createState() => _StartRoundButtonState();
}

class _StartRoundButtonState extends State<StartRoundButton> {
  @override
  void initState() {
    _color = kPrimaryBlue;
    super.initState();
  }

  Color _color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, '/CalendarScreen');
            setState(() {
              _color = kForegroundGrey;
            });
          },
          child: Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(start: 0.0, end: 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: kPrimaryBlue,
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 156.0, middle: widget.position),
          Pin(start: 13.0, end: 14.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 156.0,
              height: 30.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromPins(
                    Pin(startFraction: 0.0, endFraction: 0.0),
                    Pin(startFraction: -0.0345, endFraction: 0.0),
                    child: Text(
                      widget.text,
                      style: kButtonTextStyle,
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
    );
  }
}
