import 'package:flutter/material.dart';

/*
Colours
 */
const Color kBackgroundGrey = Color(0xFF404040);
const Color kForegroundGrey = Color(0xFF555555);
const Color kPrimaryBlue = Color(0xFF3F51B5);
const Color kEventBlue = Color(0xFF0D9DAD);
const Color kCategoryTile = Color(0xFFC6CBE9);
const Color kColorStyle1 = Color(0xFF20535A);
const Color kColorStyle2 = Color(0xFF619494);
const Color kColorStyle3 = Color(0xFF7C9885);
const Color kGreyishWhite = Color(0xffa8a8a8);
const Color kGroupBoxGrad1 = Color(0xff43cea2);
const Color kGroupBoxGrad2 = Color(0xff185a9d);
const Color kGroupInfoImageBackground = Color(0xff3a4256);

class ContactInitialsColors {
  static final color = {
    'A': Color(0xFFAA0DFE),
    'B': Color(0xFF3283FE),
    'C': Color(0xFF85660D),
    'D': Color(0xFF782AB6),
    'E': Color(0xFF565656),
    'F': Color(0xFF1C8356),
    'G': Color(0xFF16FF32),
    'H': Color(0xFFF7E1A0),
    'I': Color(0xFFE2E2E2),
    'J': Color(0xFF1CBE4F),
    'K': Color(0xFFC4451C),
    'L': Color(0xFFDEA0FD),
    'M': Color(0xFFFE00FA),
    'N': Color(0xFF325A9B),
    'O': Color(0xFFFEAF16),
    'P': Color(0xFFF8A19F),
    'Q': Color(0xFF90AD1C),
    'R': Color(0xFFF6222E),
    'S': Color(0xFF1CFFCE),
    'T': Color(0xFF2ED9FF),
    'U': Color(0xFFB10DA1),
    'V': Color(0xFFC075A6),
    'W': Color(0xFFFC1CBF),
    'X': Color(0xFFB00068),
    'Y': Color(0xFFFBE426),
    'Z': Color(0xFFFA0087),
  };

  static Color getColor(String atsign) {
    if (atsign[0] == '@') {
      return color['${atsign[1].toUpperCase()}'];
    }

    return color['${atsign[0].toUpperCase()}'];
  }
}

/*
Text Styles
and a commonly used border radius
 */
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
  fontSize: 22,
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
  fontSize: 14,
  color: Colors.white,
  letterSpacing: 0.7,
  fontWeight: FontWeight.w400,
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

const kEventDetailsTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);

/*
Important App Data Constants
 */

/*
Unusable symbols for AtKey.keys and AtSigns
The trick is replace them with a word so the customer
can still use these symbols in there event titles

I limited the length of the replacements to 5 chars each as to not take too much space in the replacement.
 */

class KeyConstants {
  static Map<String, String> badCharMap = {
    '!': 'EMARK',
    '*': 'ASTER',
    "'": 'APOST',
    '(': 'LBRAK',
    ')': 'RBRAK',
    ';': 'SCOLN',
    ':': 'COLON',
    '@': 'ASIGN',
    '&': 'AMPER',
    '=': 'EQUAL',
    '+': 'PLUS',
    '\$': 'DOLLA',
    ',': 'COMMA',
    '/': 'SLASH',
    '?': 'QMARK',
    '#': 'POUND',
    '[': 'LSBRK',
    ']': 'RSBRK',
    '{': 'LCBRK',
    '}': 'RCBRK',
  };

  static Map<String, KeyType> keyTypeMap = {
    eventStart: KeyType.EVENT,
    groupStart: KeyType.GROUP,
    confirmStart: KeyType.CONFIRMATION,
    profilePicStart: KeyType.PROFILE_PIC,
  };

  //reversed of last map
  static Map<KeyType, String> keyStringMap =
      Map.fromEntries(keyTypeMap.entries.map((e) => MapEntry(e.value, e.key)));

  static const String eventStart = 'event_';
  static const String groupStart = 'group_';
  static const String confirmStart = 'confm_';
  static const String profilePicStart = 'profil_';
}

enum KeyType {
  EVENT,
  GROUP,
  CONFIRMATION,
  PROFILE_PIC,
}

/*
 @ Protocol Essentials
 */
class MixedConstants {
  static const String WEBSITE_URL = 'https://atsign.com/';
  // for local server
  static const String ROOT_DOMAIN = 'root.atsign.org';
  static const String NAMESPACE = 'bagelconservation';
  static String regex = '.$NAMESPACE@';
  static const String TERMS_CONDITIONS = 'https://atsign.com/terms-conditions/';
  static const String PRIVACY_POLICY = 'https://atsign.com/privacy-policy/';
}

class AppStrings {
  static String appNamespace = 'at_vento';
  static String regex = '.$appNamespace@';
  static const String scan_qr = "Let's Go!";
  static const String reset_keychain = "Reset Keychain";
  static const String atsign_error = 'ATSIGN_NOT_FOUND';
}

/*
API KEY/s
 */

/*const String tinyPNG_base64 =
    'YXBpOnY3QzM0M2wxeFlWQ1p3aGtCUkdIOEJZNDRWUDh5Zno0';*/ // Not needed anymore
