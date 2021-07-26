
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'home_screen.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/3_Something Went Wrong.png",
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: SizeConfig().screenHeight * 0.15,
              left: SizeConfig().screenWidth * 0.3,
              right: SizeConfig().screenWidth * 0.3,
              child: MaterialButton(
                color: kGroupBoxGrad1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()));
                },
                child: Text(
                  "Try Again".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
