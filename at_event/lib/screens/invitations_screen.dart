import 'package:at_event/Widgets/concurrent_event_request_dialog.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'package:at_event/models/ui_event.dart';
import 'invitation_details_screen.dart';
import 'package:intl/intl.dart';
import 'background.dart';
import 'package:at_event/service/client_sdk_service.dart';
import 'package:at_commons/at_commons.dart';



void main() => runApp(InvitationsScreen());

class InvitationsScreen extends StatefulWidget {

  @override
  _InvitationsScreenState createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  final _clientSdkService = ClientSdkService.getInstance();
  @override
  void initState() {
    _getSharedKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: kBasicBorderRadius, color: kPrimaryBlue),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 46,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        'You have ' +
                            globalInvites.length.toString() +
                            ' invitations',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: globalInvites.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return InviteDetailsScreen(
                                          invite: globalInvites[index]);
                                    }));
                                  },
                                  padding: EdgeInsets.zero,
                                  minWidth: 0,
                                  child: Container(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          globalInvites[index].event.eventName,
                                          style:
                                              kEventDetailsTextStyle.copyWith(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateFormat('yyyy MMMM dd  hh:mm')
                                                  .format(
                                                      globalInvites[index].event.from)
                                                  .toString() +
                                              " - " +
                                              DateFormat('hh:mm')
                                                  .format(
                                                      globalInvites[index].event.to)
                                                  .toString(),
                                          style: kEventDetailsTextStyle,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'From ' +
                                              globalInvites[index].from +
                                              '\n' +
                                              'At ' +
                                              globalInvites[index].event.location,
                                          style:
                                              kEventDetailsTextStyle.copyWith(
                                            color: kEventBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      minWidth: 0,
                                      padding: EdgeInsets.zero,
                                      color: Colors.green,
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      minWidth: 0,
                                      padding: EdgeInsets.zero,
                                      color: Colors.red,
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the list of Shared Recipes keys.
  _getSharedKeys() async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    return await clientSdkService.getAtKeys(regex:'cached.*'+MixedConstants.NAMESPACE);
  }

  _getSharedEvents() async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();

    List<AtKey> sharedKeysList = await _getSharedKeys();

    Map recipesMap = {};

    AtKey atKey = AtKey();
    Metadata metadata = Metadata()..isCached = true;

    sharedKeysList.forEach((element) async {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;
      String response = await clientSdkService.get(atKey);
      print("Key: "+atKey.key +"\nValue: "+response);
      if (response != null)
        recipesMap.putIfAbsent('${element.key}', () => response);
    });
    // Return the entire map of shared recipes
    return recipesMap;
  }
}
