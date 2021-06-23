import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/at_common_flutter.dart';

class ErrorScreen extends StatelessWidget {
  final Function onPressed;
  ErrorScreen({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Something went wrong.'),
          SizedBox(height: 10),
          CustomButton(
              buttonText: 'Retry',
              width: 120.toWidth,
              height: 40.toHeight,
              buttonColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              onPressed: () async {
                if (onPressed != null) {
                  onPressed();
                }
              }),
        ],
      ),
    );
  }
}
