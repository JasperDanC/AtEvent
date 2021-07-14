import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';

import 'package:at_event/utils/constants.dart';

class ContactInitial extends StatelessWidget {
  final double size;
  final String initials;
  final Color backgroundColor;
  ContactInitial({Key key, this.size = 50, this.initials, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if (initials.length < 3) {
      index = initials.length;
    } else {
      index = 3;
    }
    return Container(
      height: size.toHeight,
      width: size.toHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? ContactInitialsColors.getColor(initials),
        borderRadius: BorderRadius.circular(size.toWidth),
      ),
      child: Center(
        child: Text(
          initials.substring((index == 1) ? 0 : 1, index).toUpperCase(),
          style: kNormalTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
