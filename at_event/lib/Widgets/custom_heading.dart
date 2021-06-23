import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  final String heading, action;
  final Function onPressed;
  CustomHeading({this.heading, this.action, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        heading != null
            ? Text(heading,
                style: Theme.of(context).brightness == Brightness.dark
                    ? kHeadingTextStyle.copyWith(color: Colors.black)
                    : kHeadingTextStyle.copyWith(color: Colors.white))
            : SizedBox(),
        action != null
            ? TextButton(
                onPressed: onPressed,
                child: Text(action, style: kNormalTextStyle),
              )
            : SizedBox()
      ],
    );
  }
}
