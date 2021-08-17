import 'package:at_chat_flutter/screens/chat_screen.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/location_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:intl/intl.dart';
import 'calendar_screen.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/Widgets/invite_box.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'chat_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({this.event});
  final UI_Event? event;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String activeAtSign = '';
  VentoService? clientSdkService;
  late String timeText;
  bool isCreator = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    clientSdkService = VentoService.getInstance();
    if (!widget.event!.isRecurring) {
      timeText = "From: " +
          DateFormat('MMMM').format(widget.event!.startTime!) +
          " " +
          widget.event!.startTime!.day.toString() +
          " " +
          widget.event!.startTime!.hour.toString() +
          ":" +
          DateFormat('mm').format(widget.event!.startTime!) +
          "\n" +
          "To: " +
          DateFormat('MMMM').format(widget.event!.endTime!) +
          " " +
          widget.event!.endTime!.day.toString() +
          " " +
          widget.event!.endTime!.hour.toString() +
          ":" +
          DateFormat('mm').format(widget.event!.endTime!);
    } else {
      if (widget.event!.realEvent.event!.repeatCycle == RepeatCycle.WEEK) {
        timeText = getWeekString(widget.event!.realEvent.event!.occursOn!)! +
            "s\nFrom: " +
            widget.event!.startTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.event!.startTime!) +
            "\n" +
            "To: " +
            widget.event!.endTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.event!.endTime!);
      } else if (widget.event!.realEvent.event!.repeatCycle ==
          RepeatCycle.MONTH) {
        timeText = widget.event!.startTime!.day.toString() +
            " of each Month" +
            "\nFrom: " +
            widget.event!.startTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.event!.startTime!) +
            "\n" +
            "To: " +
            widget.event!.endTime!.hour.toString() +
            ":" +
            DateFormat('mm').format(widget.event!.endTime!);
      }
    }
    getAtSign();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String? categoryString;
    switch (widget.event!.category) {
      case EventCategory.Class:
        categoryString = 'Class';
        break;
      case EventCategory.Tutorial:
        categoryString = 'Tutorial';
        break;
      case EventCategory.None:
        categoryString = 'No Category';
        break;
      case EventCategory.StudySession:
        categoryString = 'Study Session';
        break;
      case EventCategory.Hangout:
        categoryString = 'Hangout';
        break;
      case EventCategory.Lab:
        categoryString = 'Lab';
        break;
      case EventCategory.StudentClubEvent:
        categoryString = 'Student Club Event';
        break;
      case null:
        categoryString = 'No Category';
    }
    if (VentoService.getInstance().compareAtSigns(
        activeAtSign, widget.event!.realEvent.atSignCreator)) isCreator = true;
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: SizeConfig().screenHeight * 0.12,
                      width: SizeConfig().screenWidth * 0.4,
                      child: Text(
                        widget.event!.eventName,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          shape: CircleBorder(),
                          padding: EdgeInsets.zero,
                          minWidth: 0.0,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarScreen()),
                            );
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 50.0.toWidth,
                          ),
                        ),
                        MaterialButton(
                          shape: CircleBorder(),
                          padding: EdgeInsets.zero,
                          minWidth: 0.0,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VentoChatScreen(
                                  chatID: widget.event!.realEvent.key,
                                  groupMembers: widget.event!.peopleGoing,
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.chat_bubble,
                            color: Colors.white,
                            size: 30.0.toWidth,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  categoryString,
                  style: kEventDetailsTextStyle,
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeText,
                      textAlign: TextAlign.end,
                      style: kEventDetailsTextStyle,
                    ),
                    Expanded(
                      child: Text(
                        widget.event!.location,
                        textAlign: TextAlign.end,
                        style: kEventDetailsTextStyle,
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.event!.description,
                      overflow: TextOverflow.visible,
                      style: kEventDetailsTextStyle,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  widget.event!.realEvent.invitees.length.toString() +
                      " invited:",
                  style: kEventDetailsTextStyle,
                ),
                InviteBox(
                  invitees: widget.event!.invitees,
                  onAdd: _updateAndInvite,
                  addToList: true,
                  width: 300.0,
                  isCreator: isCreator,
                  height: 200.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: isCreator
                      ? [
                          FloatingActionButton(
                            heroTag: 'different_tag',
                            onPressed: () {
                              _delete(context);
                            },
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.delete,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton(
                              child: Icon(Icons.map,
                                  size: 38, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MapScreen(
                                            lat: widget.event!.realEvent
                                                .setting!.latitude,
                                            lon: widget.event!.realEvent
                                                .setting!.longitude),
                                  ),
                                );
                              }),
                          // FloatingActionButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             EventEditScreen(event: widget.event),
                          //       ),
                          //     );
                          //   },
                          //   backgroundColor: kPrimaryBlue,
                          //   child: Icon(
                          //     Icons.edit,
                          //     size: 38,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ]
                      : [
                          FloatingActionButton(
                              child: Icon(Icons.map,
                                  size: 38, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MapScreen(
                                            lat: widget.event!.realEvent
                                                .setting!.latitude,
                                            lon: widget.event!.realEvent
                                                .setting!.longitude),
                                  ),
                                );
                              }),
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //only works if the user made the event
  //which makes sense because we don't want people to delete other people's
  //events
  _delete(BuildContext context) async {
    // just a safety check

    //get that client
    VentoService clientSdkService = VentoService.getInstance();

    //create a key
    AtKey atKey = AtKey();
    atKey.key = widget.event!.realEvent.key;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = widget.event!.realEvent.atSignCreator;
    Metadata metaData = Metadata()..ccd = true;
    atKey.metadata = metaData;

    print("Deleting key:" + atKey.toString());
    //delete the key from the secondary
    bool deleteResult = await clientSdkService.delete(atKey);

    print("Delete Result:" + deleteResult.toString());

    //delete the event that exists as a invitation to someone else
    for (String invitee in widget.event!.invitees) {
      //make a key again with the right sharedWith + sharedBy
      AtKey atKey = AtKey();
      atKey.key = widget.event!.realEvent.key.toLowerCase().replaceAll(' ', '');
      atKey.sharedWith = invitee;
      atKey.sharedBy =
          widget.event!.realEvent.atSignCreator.replaceAll("@", "");
      Metadata metaData = Metadata()..ccd = true;
      atKey.metadata = metaData;
      await clientSdkService.delete(atKey);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CalendarScreen()));
  }

  _updateAndInvite() async {
    setState(() {});
    //create and update the event in the secondary so that the invitee added
    //is kept track of in the secondary as well
    AtKey atKey = AtKey();
    atKey.key = widget.event!.realEvent.key;
    atKey.namespace = MixedConstants.NAMESPACE;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = activeAtSign;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;

    String storedValue = EventNotificationModel.convertEventNotificationToJson(
        widget.event!.realEvent);

    await VentoService.getInstance().put(atKey, storedValue);
    await VentoService.getInstance().shareWithMany(
        atKey.key, storedValue, activeAtSign, widget.event!.invitees);
  }

  //simple atSign getter
  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
