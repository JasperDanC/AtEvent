import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:at_event/screens/event_create_screen.dart';
import 'package:at_event/screens/home_screen.dart';
import 'package:at_event/screens/invitations_screen.dart';
import 'package:at_event/screens/recurring_event.dart';
import 'package:at_event/service/image_anonymous_authentication.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/WelcomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:at_event/screens/something_went_wrong.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'models/user_image_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Vento());
}

class Vento extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _VentoState createState() => _VentoState();
}

class _VentoState extends State<Vento> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (_error) {
      return SomethingWentWrongScreen();
    }

    if (!_initialized) {
      return Background(
        child: Center(
          child: SpinKitFoldingCube(
            color: kPrimaryBlue,
            size: 50.0,
          ),
        ),
        turnAppbar: false,
        loggedIn: false,
      );
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserImageModel?>.value(
            value: AnonymousAuthService().user,
            initialData: null,
          ),
          ChangeNotifierProvider<UIData>(
            create: (context) => UIData(),
          ),
        ],
        child: MaterialApp(
          title: '@Vento',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              primaryColor: kForegroundGrey,
              scaffoldBackgroundColor: kBackgroundGrey,
            ),
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) => WelcomeScreen(),
              '/HomeScreen': (BuildContext context) => HomeScreen(),
              '/CalendarScreen': (BuildContext context) => CalendarScreen(),
              '/EventCreateScreen': (BuildContext context) =>
                  EventCreateScreen(),
              '/InvitationsScreen': (BuildContext context) =>
                  InvitationsScreen(),
              '/RecurringEvent': (BuildContext context) => RecurringEvent(),
            }),
      );
    }
  }
}
