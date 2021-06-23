import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  final String heading, action;
  CustomHeading({this.heading, this.action});

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
        action != null ? Text(action, style: kNormalTextStyle) : SizedBox()
      ],
    );
  }
}
