import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Custom Toast Widget that lasts for one second
///
class CustomToast {
  CustomToast._();
  static final CustomToast _instance = CustomToast._();
  factory CustomToast() => _instance;

  void show(String text, BuildContext context,
      {Color? bgColor, Color? textColor, int duration = 3}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor ?? kColorStyle1,
        textColor: textColor ?? Colors.white,
        fontSize: 16.0);
  }
}
