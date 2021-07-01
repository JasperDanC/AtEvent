import 'package:flutter/material.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/models/invite.dart';

/*
Colors and Styles
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

List<UI_Event> kDummyEvents = [
  UI_Event(
      eventName: "Test Event 1",
      from: DateTime(2021, 06, 09, 6),
      to: DateTime(2021, 06, 09, 9)),
  UI_Event(
      eventName: "Test Event 2",
      from: DateTime(2021, 06, 10, 18),
      to: DateTime(2021, 06, 10, 21)),
  UI_Event(
      eventName: "Test Event 3",
      from: DateTime(2021, 06, 14, 10),
      to: DateTime(2021, 06, 14, 11)),
  UI_Event(
      eventName: "Test Event 4",
      from: DateTime(2021, 06, 22, 6),
      to: DateTime(2021, 06, 22, 9)),
];
List<Invite> kDummyInvites = [
  Invite(
    from: '@bobert',
    event: UI_Event(
        eventName: "Lunch with Thomas",
        from: DateTime(2021, 06, 09, 6),
        to: DateTime(2021, 06, 09, 9),
        location: '123 Street Avenue N.',
        description: 'Lunch at my place!\n\n' +
            'Bring some board games, pops, and some delicious sides\n\n' +
            'We will be eating burgers',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
          '@Harriet',
          '@funkyfrog',
          '@3frogs',
          '@dagoth_ur',
          '@clavicus_vile',
          '@BenjaminButton',
          '@samus',
          '@atom_eve',
          '@buggs',
          '@george',
        ]),
  ),
  Invite(
    from: '@frankyG',
    event: UI_Event(
        eventName: "Party Time",
        from: DateTime(2021, 06, 09, 18),
        to: DateTime(2021, 06, 09, 22),
        location: 'FrankyG House, Saskatoon',
        description: 'we getting wild',
        peopleGoing: []),
  ),
  Invite(
    from: '@your_boss',
    event: UI_Event(
        eventName: "Important Business Meeting",
        from: DateTime(2021, 06, 09, 14, 30),
        to: DateTime(2021, 06, 09, 18, 45),
        location: '56 Business Street',
        description: 'business',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
        ]),
  ),
  Invite(
    from: '@gerald',
    event: UI_Event(
        eventName: "Gerald + Gertrude Wedding",
        from: DateTime(2021, 06, 09, 12),
        to: DateTime(2021, 06, 09, 24),
        location: ' 99 RoadName Boulevard, Prince Albert, Saskatchewan',
        description: 'I am getting married\n\n' +
            'pls come\n' +
            'casual dress is prefered',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
          '@Harriet',
          '@funkyfrog',
          '@3frogs',
          '@dagoth_ur',
          '@clavicus_vile',
          '@BenjaminButton',
          '@samus',
          '@atom_eve',
          '@buggs',
          '@george',
          '@sam',
          '@5678',
          '@jaz',
          '@bagelconservation',
          '@samantha',
          '@geralds_mom',
          '@samuel',
          '@sammy',
          '@gertrude',
          '@frank',
          '@otherpeople',
          '@someone',
          '@buggs2',
          '@george2'
        ]),
  ),
  Invite(
    from: '@bobert',
    event: UI_Event(
        eventName: "Lunch with Thomas",
        from: DateTime(2021, 06, 09, 11),
        to: DateTime(2021, 06, 09, 13),
        location: '123 Street Avenue N.',
        description: 'Lunch at my place!\n\n' +
            'Bring some board games, pops, and some delicious sides\n\n' +
            'We will be eating burgers',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
          '@Harriet',
          '@funkyfrog',
          '@3frogs',
          '@dagoth_ur',
          '@clavicus_vile',
          '@BenjaminButton',
          '@samus',
          '@atom_eve',
          '@buggs',
          '@george',
        ]),
  ),
];

List<UI_Event> globalUIEvents = [];
List<Invite> globalInvites = [];
/*
Important App Data
*/

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

final String namespace = 'bagelconservation';
