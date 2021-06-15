import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      loggedIn: false,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryBlue),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                    'assets/images/People_on_seafront_15.jpg'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 50, bottom: 50),
                              child: Text(
                                '"Some people look for a beautiful place. Others make a place beautiful."\n-Hazrat Inavat Khan',
                                style: kQuoteTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/OnboardingScreen');
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    primary: kColorStyle3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Text('Getting Started',
                                    style: kButtonTextStyle))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
