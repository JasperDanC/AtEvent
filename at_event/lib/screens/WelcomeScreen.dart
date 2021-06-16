import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/client_sdk_service.dart';
import '../utils/constants.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
      loggedIn: false,
      child: Container(
        height: 550,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryBlue),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 175,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                clipBehavior: Clip.antiAlias,
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/People_on_seafront_15.jpg'),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 50, bottom: 50),
                              child: Text(
                                '"Some people look for a beautiful place. Others make a place beautiful."\n-Hazrat Inavat Khan',
                                style: kQuoteTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () async {
                                    // TODO: Add in at_onboarding_flutter
                                    Onboarding(
                                      context: context,
                                      atClientPreference: atClientPreference,
                                      domain: MixedConstants.ROOT_DOMAIN,
                                      appColor: kPrimaryBlue,
                                      onboard: (value, atsign) {
                                        ClientSdkService.getInstance()
                                            .atClientServiceMap = value;
                                        ClientSdkService.getInstance()
                                                .atClientServiceInstance =
                                            value[atsign];
                                        _logger.finer(
                                            'Successfully onboarded $atsign');
                                      },
                                      onError: (error) {
                                        _logger.severe(
                                            'Onboarding throws $error error');
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
                                var _atSignsList = await _keyChainManager
                                    .getAtSignListFromKeychain();
                                _atSignsList?.forEach((element) {
                                  _keyChainManager
                                      .deleteAtSignFromKeychain(element);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  'Keychain cleaned',
                                  textAlign: TextAlign.center,
                                )));
                              },
                              child: Text(
                                AppStrings.reset_keychain,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
