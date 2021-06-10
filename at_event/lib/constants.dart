import 'package:flutter/material.dart';

const Color kBackgroundGrey = Color(0xFF555555);
const Color kForegroundGrey = Color(0xFF404040);
const Color kPrimaryBlue = Color(0xFF3F51B5);
const Color kEventBlue = Color(0xFF0D9DAD);
const BorderRadius kBasicBorderRadius = BorderRadius.all(
  Radius.circular(75.0),
);
const kTitleTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 50,
  color: const Color(0xffd49999),
  letterSpacing: 0.7000000000000001,
  fontWeight: FontWeight.w600,
  shadows: [
    Shadow(
      color: const Color(0xa8000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    )
  ],
);

const kQuoteTextStyle = TextStyle(
  fontFamily: 'Segoe UI',
  fontSize: 22,
  color: const Color(0xfff1f1f1),
  shadows: [
    Shadow(
      color: const Color(0x8f000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    )
  ],
);

const kButtonTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 22,
  color: const Color(0xfff1f1f1),
  height: 1.8,
);

const kEventDetailsTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);

AppBar globalAppBar = AppBar(
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
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
  ),
);
