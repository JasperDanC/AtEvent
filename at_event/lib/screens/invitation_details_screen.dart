import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'background.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/service/vento_services.dart';

class InviteDetailsScreen extends StatefulWidget {
  InviteDetailsScreen(
      {this.eventInvite, this.groupInvite, required this.isEvent});
  final EventInvite? eventInvite;
  final GroupInvite? groupInvite;
  final bool isEvent;

  @override
  _InviteDetailsScreenState createState() => _InviteDetailsScreenState();
}

class _InviteDetailsScreenState extends State<InviteDetailsScreen> {
  late String timeText;
  String activeAtSign = '';
  @override
  void initState() {
    getAtSign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEvent) {
      if (!widget.eventInvite!.event.isRecurring) {
        timeText = "From: " +
            DateFormat('MMMM').format(widget.eventInvite!.event.startTime!) +
            " " +
            widget.eventInvite!.event.startTime!.day.toString() +
            " " +
            widget.eventInvite!.event.startTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.eventInvite!.event.startTime!) +
            "\n" +
            "To: " +
            DateFormat('MMMM').format(widget.eventInvite!.event.endTime!) +
            " " +
            widget.eventInvite!.event.endTime!.day.toString() +
            " " +
            widget.eventInvite!.event.endTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.eventInvite!.event.endTime!);
      } else {
        if (widget.eventInvite!.event.realEvent.event.repeatCycle ==
            RepeatCycle.WEEK) {
          timeText = getWeekString(
                  widget.eventInvite!.event.realEvent.event.occursOn!)! +
              "s\nFrom: " +
              widget.eventInvite!.event.startTime!.hour.toString() +
              ":" +
              DateFormat('mm').format(widget.eventInvite!.event.startTime!) +
              "\n" +
              "To: " +
              widget.eventInvite!.event.endTime!.hour.toString() +
              ":" +
              DateFormat('mm').format(widget.eventInvite!.event.endTime!);
        } else if (widget.eventInvite!.event.realEvent.event.repeatCycle ==
            RepeatCycle.MONTH) {
          timeText = widget.eventInvite!.event.startTime!.day.toString() +
              " of each Month" +
              "\nFrom: " +
              widget.eventInvite!.event.startTime!.hour.toString() +
              ":" +
              DateFormat('mm').format(widget.eventInvite!.event.startTime!) +
              "\n" +
              "To: " +
              widget.eventInvite!.event.endTime!.hour.toString() +
              ":" +
              DateFormat('mm').format(widget.eventInvite!.event.endTime!);
        }
      }
    }

    return Background(
      child: Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 100,
              horizontal: 30,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: kBasicBorderRadius, color: kPrimaryBlue),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Invitation from ' +
                                (widget.isEvent
                                    ? widget.eventInvite!.from
                                    : widget.groupInvite!.from),
                            style: kEventDetailsTextStyle,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.zero,
                          minWidth: 0,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Text(
                      widget.isEvent
                          ? widget.eventInvite!.event.eventName
                          : widget.groupInvite!.group.title!,
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Column(
                      children: widget.isEvent
                          ? [
                              Divider(
                                color: Colors.white,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (widget.isEvent ? timeText : ''),
                                        textAlign: TextAlign.end,
                                        style: kEventDetailsTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.isEvent
                                            ? widget.eventInvite!.event.location
                                            : '',
                                        textAlign: TextAlign.end,
                                        style: kEventDetailsTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ]
                          : [],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.isEvent
                              ? widget.eventInvite!.event.description
                              : widget.groupInvite!.group.description!,
                          overflow: TextOverflow.visible,
                          style: kEventDetailsTextStyle,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Text(
                      widget.isEvent
                          ? widget.eventInvite!.event.peopleGoing.length
                                  .toString() +
                              " going"
                          : widget.groupInvite!.group.atSignMembers.length
                                  .toString() +
                              " members",
                      style: kEventDetailsTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            _sendConfirmation(
                                isEvent: widget.isEvent,
                                groupInvite: widget.groupInvite,
                                eventInvite: widget.eventInvite);
                          },
                          minWidth: 0,
                          padding: EdgeInsets.zero,
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 77,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _deleteInvitation(
                                isEvent: widget.isEvent,
                                groupInvite: widget.groupInvite,
                                eventInvite: widget.eventInvite);
                          },
                          minWidth: 0,
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 77,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
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
    VentoService.getInstance().scan(context);
    Navigator.pop(context);
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
    VentoService.getInstance().scan(context);
    Navigator.pop(context);
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
