import 'package:at_event/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: kPrimaryBlue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/People_on_seafront_15.jpg',
                    scale: 2,
                  ),
                ),
                Text(
                  '"Some people look for a beautiful place. Others make a place beautiful.\n-Hazrat Inavat Khan"',
                  style: kQuoteTextStyle,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/HomeScreen');
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: Colors.black,
                          primary: kPrimaryBlue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text('Getting Started', style: kButtonTextStyle)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
