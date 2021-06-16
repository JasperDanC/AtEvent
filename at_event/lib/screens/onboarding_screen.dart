import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../service/client_sdk_service.dart';
import '../utils/constants.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'home_screen.dart';
import 'background.dart';

class OnboardingScreen extends StatefulWidget {

  @override
  _OnboardingScreen createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
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
    return MaterialApp(
      home: Background(
        loggedIn: false,
        child: Expanded(
          child: Builder(
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                            ClientSdkService.getInstance().atClientServiceMap =
                                value;
                            ClientSdkService.getInstance()
                                .atClientServiceInstance = value[atsign];
                            _logger.finer('Successfully onboarded $atsign');
                          },
                          onError: (error) {
                            _logger.severe('Onboarding throws $error error');
                          },
                          nextScreen: HomeScreen(),
                        );
                      },
                      child: Text(AppStrings.scan_qr)),
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
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}