import 'package:flutter/material.dart';
import 'package:at_event/models/event.dart';

const Color kBackgroundGrey = Color(0xFF555555);
const Color kForegroundGrey = Color(0xFF404040);
const Color kPrimaryBlue = Color(0xFF3F51B5);
const Color kEventBlue = Color(0xFF0D9DAD);
const Color kCategoryTile = Color(0xFFC6CBE9);
const Color kColorStyle1 = Color(0xFF20535A);
const Color kColorStyle2 = Color(0xFF619494);
const Color kColorStyle3 = Color(0xFF7C9885);

const BorderRadius kBasicBorderRadius = BorderRadius.all(
  Radius.circular(75.0),
);
const kTitleTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 50,
  color: Colors.white,
  letterSpacing: 0.7,
  fontWeight: FontWeight.w600,
  shadows: [
    Shadow(
      color: const Color(0xa8000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    )
  ],
);
const kHeadingTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 26,
  color: Colors.white,
  letterSpacing: 0.7,
  fontWeight: FontWeight.w600,
  shadows: [
    Shadow(
      color: const Color(0xa8000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    )
  ],
);

const kSubHeadingTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 20,
  color: Colors.white,
  letterSpacing: 0.7,
  fontWeight: FontWeight.w600,
  shadows: [
    Shadow(
      color: const Color(0xa8000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    )
  ],
);
const kNormalTextStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 17,
  color: Colors.white,
  letterSpacing: 0.7,
  fontWeight: FontWeight.w300,
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

List<Event> kDummyEvents = [
  Event(
      eventName: "Test Event 1",
      from: DateTime(2021, 06, 09, 6),
      to: DateTime(2021, 06, 09, 9)),
  Event(
      eventName: "Test Event 2",
      from: DateTime(2021, 06, 10, 18),
      to: DateTime(2021, 06, 10, 21)),
  Event(
      eventName: "Test Event 3",
      from: DateTime(2021, 06, 14, 10),
      to: DateTime(2021, 06, 14, 11)),
  Event(
      eventName: "Test Event 4",
      from: DateTime(2021, 06, 22, 6),
      to: DateTime(2021, 06, 22, 9)),
];

class MixedConstants {
  static const String WEBSITE_URL = 'https://atsign.com/';
  // for local server
  static const String ROOT_DOMAIN = 'root.atsign.org';
  static const String NAMESPACE = 'at_chat';
  static const String TERMS_CONDITIONS = 'https://atsign.com/terms-conditions/';
  static const String PRIVACY_POLICY = 'https://atsign.com/privacy-policy/';
}

class AppStrings {
  static String appNamespace = 'at_chat_demo';
  static String regex = '.$appNamespace@';
  static const String scan_qr = "Let's Go!";
  static const String reset_keychain = "Reset Keychain";
  static const String atsign_error = 'ATSIGN_NOT_FOUND';
}
