import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/client_sdk_service.dart';
import '../utils/constants.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_event/utils/functions.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int _numPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  bool showSpinner = false;
  String atSign;
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();
  var atClientPreference;
  var _logger = AtSignLogger('Plugin example app');
  @override
  void initState() {
    ClientSdkService.getInstance().onboard();
    ClientSdkService.getInstance()
        .getAtClientPreference()
        .then((value) => atClientPreference = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 575,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kColorStyle1),
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 265,
                                width: 325,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Onboarding0.jpg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Attend your classes\nstress free!',
                              style: kTitleTextStyle.copyWith(fontSize: 26),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Never miss a class update ever again!\nWith @Vento, we got you covered.\n\nAll your important class info at the palm of your hand.',
                              style: kNormalTextStyle.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Onboarding1.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Hangout with people\naround Campus!',
                              style: kTitleTextStyle.copyWith(fontSize: 26),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              '"Some people look for a beautiful place. Others make a place beautiful."\n-Hazrat Inavat Khan',
                              style: kNormalTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Onboarding2.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Prepare with classmates!\nPlanning was never easier',
                              style: kTitleTextStyle.copyWith(fontSize: 26),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Creating and organizing a group study session is a breeze!\nDon't waste any time planning, dive straight into studying!",
                              style: kNormalTextStyle.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Onboarding3.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Elevate each other!\nMake the most out of every moment!',
                              style: kTitleTextStyle.copyWith(fontSize: 26),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Hard work pays off!\nWe are here to celebrate your accomplishments with you. Get all your friends together to commemorate your success!',
                              style: kNormalTextStyle.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Onboarding4.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'All the class info you need neatly organized for you',
                              style: kTitleTextStyle.copyWith(fontSize: 26),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'User friendly layout so that you can access everything with just a couple of taps.',
                              style: kNormalTextStyle.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: kColorStyle2,
                        onSurface: kColorStyle3,
                        shadowColor: Colors.purple),
                    onPressed: () async {
                      Onboarding(
                        context: context,
                        atClientPreference: atClientPreference,
                        domain: MixedConstants.ROOT_DOMAIN,
                        appColor: kPrimaryBlue,
                        onboard: (value, atsign) async {
                          ClientSdkService.getInstance().atClientServiceMap =
                              value;
                          ClientSdkService.getInstance()
                              .atClientServiceInstance = value[atsign];
                          _logger.finer('Successfully onboarded $atsign');
                          await startMonitor(atsign);
                        },
                        onError: (error) {
                          _logger.severe('Onboarding throws $error error');
                        },
                        nextScreen: HomeScreen(),
                      );
                    },
                    child: Text(
                      AppStrings.scan_qr,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  KeyChainManager _keyChainManager =
                      KeyChainManager.getInstance();
                  var _atSignsList =
                      await _keyChainManager.getAtSignListFromKeychain();
                  _atSignsList?.forEach((element) {
                    _keyChainManager.deleteAtSignFromKeychain(element);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Keychain cleaned',
                    textAlign: TextAlign.center,
                  )));
                },
                child: Text(
                  AppStrings.reset_keychain,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        loggedIn: false,
        turnAppbar: false);
  }
}
