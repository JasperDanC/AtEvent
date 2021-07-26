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

  List<EventInvite> eventInvites = [];
  List<GroupInvite> groupInvites = [];
  @override
  void initState() {
    getAtSign();
    VentoService.getInstance().scan(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    eventInvites.clear();
    groupInvites.clear();
    eventInvites.addAll(Provider.of<UIData>(context).eventInvites);
    groupInvites.addAll(Provider.of<UIData>(context).groupInvites);
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
                            (eventInvites.length + groupInvites.length)
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
                          itemCount: eventInvites.length,
                          itemBuilder: (context, index) {
                            late String timeText;
                            if (!eventInvites[index].event.isRecurring) {
                              timeText = DateFormat('yyyy MMMM dd  hh:mm a')
                                      .format(
                                          eventInvites[index].event.startTime!)
                                      .toString() +
                                  " - " +
                                  DateFormat('hh:mm a')
                                      .format(eventInvites[index].event.endTime!)
                                      .toString();
                            } else {
                              EventInvite eventInvite = eventInvites[index];
                              if (eventInvite
                                      .event.realEvent.event.repeatCycle ==
                                  RepeatCycle.WEEK) {
                                timeText = getWeekString(eventInvite
                                        .event.realEvent.event.occursOn!)! +
                                    "s\nFrom: " +
                                    DateFormat('hh:mm a')
                                        .format(
                                            eventInvites[index].event.startTime!)
                                        .toString() +
                                    "\n" +
                                    "To: " +
                                    DateFormat('hh:mm a')
                                        .format(
                                            eventInvites[index].event.endTime!)
                                        .toString();
                              } else if (eventInvite
                                      .event.realEvent.event.repeatCycle ==
                                  RepeatCycle.MONTH) {
                                timeText = eventInvite.event.startTime!.day
                                        .toString() +
                                    " each month" +
                                    "\nFrom: " +
                                    DateFormat('hh:mm a')
                                        .format(
                                            eventInvites[index].event.startTime!)
                                        .toString() +
                                    " " +
                                    "To: " +
                                    DateFormat('hh:mm a')
                                        .format(
                                            eventInvites[index].event.endTime!)
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
                                      onPressed: eventInvites.length > index ? () {

                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {

                                          EventInvite copyOfInvite = EventInvite(event: eventInvites[index].event, from: eventInvites[index].from);
                                          return InviteDetailsScreen(
                                            eventInvite: copyOfInvite,
                                            isEvent: true,
                                          );
                                        }));
                                      } : (){},
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      child: Container(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eventInvites[index]
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
                                                  eventInvites[index].from +
                                                  '\n' +
                                                  'At ' +
                                                  eventInvites[index]
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
                                                    eventInvites[index],
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
                                                    eventInvites[index],
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
                          itemCount: groupInvites.length,
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
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return InviteDetailsScreen(
                                            groupInvite: groupInvites[index],
                                            isEvent: false,
                                          );
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
                                              groupInvites[index].group.title!,
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
                                                  groupInvites[index].from +
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
                                                    groupInvites[index],
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
                                                    groupInvites[index],
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
      {EventInvite? eventInvite,
      GroupInvite? groupInvite,
      required bool isEvent}) async {
    AtKey atKey = AtKey();
    if (isEvent) {
      eventInvite!.event.realEvent.peopleGoing.add(activeAtSign);
      atKey.key = KeyConstants.confirmStart + eventInvite.event.realEvent.key;
      atKey.sharedWith = eventInvite.event.realEvent.atSignCreator;
      Provider.of<UIData>(context, listen: false)
          .acceptEventInvite(eventInvite);
    } else {
      groupInvite!.group.atSignMembers.add(activeAtSign);
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
          eventInvite!.event.realEvent);
    } else {
      storedValue = GroupModel.convertGroupToJson(groupInvite!.group);
    }
    var operation = OperationEnum.update;
    await VentoService.getInstance().notify(atKey, storedValue, operation);
  }

  _deleteInvitation(
      {EventInvite? eventInvite,
      GroupInvite? groupInvite,
      required bool isEvent}) async {
    AtKey atKey = AtKey();
    if (isEvent) {
      atKey.key = eventInvite!.event.realEvent.key;
      Provider.of<UIData>(context, listen: false)
          .deleteEventInvite(eventInvite);
    } else {
      atKey.key = groupInvite!.group.key;
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
          eventInvite!.event.realEvent);
      atKey.sharedWith =
          eventInvite.event.realEvent.atSignCreator.replaceAll("@", "");
    } else {
      storedValue = GroupModel.convertGroupToJson(groupInvite!.group);
      atKey.sharedWith = groupInvite.group.atSignCreator.replaceAll("@", "");
    }

    //await ClientSdkService.getInstance().delete(atKey);

    atKey.key = atKey.key;
    print("Deleting: " + atKey.toString());

    var operation = OperationEnum.delete;
    await VentoService.getInstance().notify(atKey, storedValue, operation);
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
