import 'package:flutter/material.dart';

const Color kBackgroundGrey = Color(0xFF555555);
const Color kForegroundGrey = Color(0xFF404040);
const Color kPrimaryBlue = Color(0xFF3F51B5);
const Color kEventBlue = Color(0xFF0D9DAD);

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
);
