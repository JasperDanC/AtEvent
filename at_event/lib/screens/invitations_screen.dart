import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'invitation_details_screen.dart';
import 'package:intl/intl.dart';
import 'background.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_commons/at_commons.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_event/models/group_model.dart';

void main() => runApp(InvitationsScreen());

class InvitationsScreen extends StatefulWidget {
  @override
  _InvitationsScreenState createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  int switchIndex = 0;
  String activeAtSign = '';
  @override
  void initState() {
    getAtSign();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
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
                            (Provider.of<UIData>(context).eventInvitesLength +
                                    Provider.of<UIData>(context)
                                        .groupInvitesLength)
                                .toString() +
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
                ToggleSwitch(
                  minWidth: 125,
                  totalSwitches: 2,
                  labels: ["Event Invites", "Group Invites"],
                  initialLabelIndex: switchIndex,
                  onToggle: (index) {
                    setState(() {
                      switchIndex = index;
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: switchIndex == 0
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount:
                              Provider.of<UIData>(context).eventInvitesLength,
                          itemBuilder: (context, index) {
                            String timeText;
                            if(!Provider.of<UIData>(context)
                                .getEventInvite(index).event.isRecurring){
                              timeText = DateFormat('yyyy MMMM dd  hh:mm a')
                                  .format(Provider.of<
                                  UIData>(context)
                                  .eventInvites[index]
                                  .event
                                  .startTime)
                                  .toString() +
                                  " - " +
                                  DateFormat('hh:mm a')
                                      .format(Provider.of<
                                      UIData>(context)
                                      .eventInvites[index]
                                      .event
                                      .endTime)
                                      .toString();
                            } else {
                               EventInvite eventInvite = Provider.of<UIData>(context)
                                   .getEventInvite(index);
                              if (eventInvite.event.realEvent.event.repeatCycle == RepeatCycle.WEEK) {
                                timeText = getWeekString(eventInvite.event.realEvent.event.occursOn) +
                                    "s\nFrom: " +
                                    DateFormat('hh:mm a')
                                        .format(Provider.of<
                                        UIData>(context)
                                        .eventInvites[index]
                                        .event
                                        .startTime)
                                        .toString() +
                                    "\n" +
                                    "To: " + DateFormat('hh:mm a')
                                    .format(Provider.of<
                                    UIData>(context)
                                    .eventInvites[index]
                                    .event
                                    .endTime)
                                    .toString();
                              } else if (eventInvite.event.realEvent.event.repeatCycle ==
                                  RepeatCycle.MONTH) {
                                timeText = eventInvite.event.startTime.day.toString() +
                                    " each month" +
                                    "\nFrom: " +DateFormat('hh:mm a')
                                    .format(Provider.of<
                                    UIData>(context)
                                    .eventInvites[index]
                                    .event
                                    .startTime)
                                    .toString() +
                                    " " +
                                    "To: " +
                                    DateFormat('hh:mm a')
                                        .format(Provider.of<
                                        UIData>(context)
                                        .eventInvites[index]
                                        .event
                                        .endTime)
                                        .toString();
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        if(index < Provider.of<UIData>(context, listen: false).eventInvitesLength ) {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return InviteDetailsScreen(
                                                      eventInvite:
                                                      Provider.of<UIData>(context)
                                                          .getEventInvite(index),
                                                      isEvent: true,
                                                    );
                                                  }));
                                        }
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
                                              Provider.of<UIData>(context)
                                                  .eventInvites[index]
                                                  .event
                                                  .eventName,
                                              style: kEventDetailsTextStyle
                                                  .copyWith(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              timeText,
                                              style: kEventDetailsTextStyle,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'From ' +
                                                  Provider.of<UIData>(context)
                                                      .eventInvites[index]
                                                      .from +
                                                  '\n' +
                                                  'At ' +
                                                  Provider.of<UIData>(context)
                                                      .eventInvites[index]
                                                      .event
                                                      .location,
                                              style: kEventDetailsTextStyle
                                                  .copyWith(
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
                                          onPressed: () {
                                            _sendConfirmation(
                                                eventInvite:
                                                    Provider.of<UIData>(context,
                                                            listen: false)
                                                        .getEventInvite(index),
                                                isEvent: true);
                                            VentoService.getInstance()
                                                .scan(context);
                                          },
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
                                          onPressed: () {
                                            _deleteInvitation(
                                                eventInvite:
                                                    Provider.of<UIData>(context,
                                                            listen: false)
                                                        .getEventInvite(index),
                                                isEvent: true);
                                          },
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
                          })
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount:
                              Provider.of<UIData>(context).groupInvitesLength,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        if(index <Provider.of<UIData>(context, listen: false).groupInvitesLength  ){
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return InviteDetailsScreen(
                                                      groupInvite:
                                                      Provider.of<UIData>(context)
                                                          .getGroupInvite(index),
                                                      isEvent: false,
                                                    );
                                                  }));
                                        }
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
                                              Provider.of<UIData>(context)
                                                  .getGroupInvite(index)
                                                  .group
                                                  .title,
                                              style: kEventDetailsTextStyle
                                                  .copyWith(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'From ' +
                                                  Provider.of<UIData>(context)
                                                      .getGroupInvite(index)
                                                      .from +
                                                  '\n',
                                              style: kEventDetailsTextStyle
                                                  .copyWith(
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
                                          onPressed: () {
                                            _sendConfirmation(
                                                groupInvite:
                                                    Provider.of<UIData>(context,
                                                            listen: false)
                                                        .getGroupInvite(index),
                                                isEvent: false);
                                            VentoService.getInstance()
                                                .scan(context);
                                          },
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
                                          onPressed: () {
                                            _deleteInvitation(
                                                groupInvite:
                                                    Provider.of<UIData>(context,
                                                            listen: false)
                                                        .getGroupInvite(index),
                                                isEvent: false);
                                          },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendConfirmation(
      {EventInvite eventInvite,
      GroupInvite groupInvite,
      @required bool isEvent}) async {
    AtKey atKey = AtKey();
    if (isEvent) {
      eventInvite.event.realEvent.peopleGoing.add(activeAtSign);
      atKey.key = KeyConstants.confirmStart + eventInvite.event.realEvent.key;
      atKey.sharedWith = eventInvite.event.realEvent.atSignCreator;
      Provider.of<UIData>(context, listen: false)
          .acceptEventInvite(eventInvite);
    } else {
      groupInvite.group.atSignMembers.add(activeAtSign);
      atKey.key = KeyConstants.confirmStart + groupInvite.group.key;
      atKey.sharedWith = groupInvite.group.atSignCreator;
      Provider.of<UIData>(context, listen: false)
          .acceptGroupInvite(groupInvite);
    }

    atKey.namespace = MixedConstants.NAMESPACE;
    atKey.sharedBy = activeAtSign;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;

    String storedValue;

    if (isEvent) {
      storedValue = EventNotificationModel.convertEventNotificationToJson(
          eventInvite.event.realEvent);
    } else {
      storedValue = GroupModel.convertGroupToJson(groupInvite.group);
    }
    var operation = OperationEnum.update;
    await VentoService.getInstance().notify(atKey, storedValue, operation);
  }

  _deleteInvitation(
      {EventInvite eventInvite,
      GroupInvite groupInvite,
      @required bool isEvent}) async {
    AtKey atKey = AtKey();
    if (isEvent) {
      atKey.key = eventInvite.event.realEvent.key;
      Provider.of<UIData>(context, listen: false)
          .deleteEventInvite(eventInvite);
    } else {
      atKey.key = groupInvite.group.key;
      Provider.of<UIData>(context, listen: false)
          .deleteGroupInvite(groupInvite);
    }

    atKey.namespace = MixedConstants.NAMESPACE;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = activeAtSign.replaceAll("@", "");
    Metadata metadata = Metadata();

    atKey.metadata = metadata;

    String storedValue;

    if (isEvent) {
      storedValue = EventNotificationModel.convertEventNotificationToJson(
          eventInvite.event.realEvent);
      atKey.sharedWith =
          eventInvite.event.realEvent.atSignCreator.replaceAll("@", "");
    } else {
      storedValue = GroupModel.convertGroupToJson(groupInvite.group);
      atKey.sharedWith = groupInvite.group.atSignCreator.replaceAll("@", "");
    }

    //await ClientSdkService.getInstance().delete(atKey);

    atKey.key = atKey.key;
    print("Deleting: " + atKey.toString());

    var operation = OperationEnum.delete;
    await VentoService.getInstance().notify(atKey, storedValue, operation);
  }

  getAtSign() async {
    String currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
