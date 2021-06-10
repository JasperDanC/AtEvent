import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/constants.dart';

class Background extends StatelessWidget {
  Background({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 65.0,
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
        body: Stack(
          children: <Widget>[
            Pinned.fromPins(
              Pin(start: 0.0, end: 0.0),
              Pin(start: 0.0, end: 0.0),
              child: Container(
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
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                child
              ],
            )
          ],
        ),
        extendBodyBehindAppBar: true,
      ),
    );
  }
}
