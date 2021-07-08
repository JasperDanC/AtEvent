import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/screens/event_edit_screen.dart';
import 'package:intl/intl.dart';
import 'calendar_screen.dart';
import 'package:at_event/service/client_sdk_service.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/widgets/invite_box.dart';

void main() {
  runApp(EventDetailsScreen(
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
        ],
        category: EventCategory.Class),
  ));
}

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({this.event});
  final UI_Event event;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String activeAtSign = '';
  ClientSdkService clientSdkService;


  @override
  void initState() {
    clientSdkService = ClientSdkService.getInstance();
    getAtSign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String categoryString;
    switch (widget.event.category) {
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
    }
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.event.eventName,
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
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
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  categoryString != null ? categoryString : "",
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
                      "From: " +
                          DateFormat('MMMM').format(widget.event.from) +
                          " " +
                          widget.event.from.day.toString() +
                          " " +
                          widget.event.from.hour.toString() +
                          ":" +
                          DateFormat('mm').format(widget.event.from) +
                          "\n" +
                          "To: " +
                          DateFormat('MMMM').format(widget.event.to) +
                          " " +
                          widget.event.to.day.toString() +
                          " " +
                          widget.event.to.hour.toString() +
                          ":" +
                          DateFormat('mm').format(widget.event.to),
                      textAlign: TextAlign.end,
                      style: kEventDetailsTextStyle,
                    ),
                    Expanded(
                      child: Text(
                        widget.event.location,
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
                      widget.event.description,
                      overflow: TextOverflow.visible,
                      style: kEventDetailsTextStyle,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  widget.event.realEvent.invitees.length.toString() + " invited:",
                  style: kEventDetailsTextStyle,
                ),
                InviteBox(
                  invitees: widget.event.invitees,
                  onAdd: _updateAndInvite,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventEditScreen(event: widget.event),
                          ),
                        );
                      },
                      backgroundColor: kPrimaryBlue,
                      child: Icon(
                        Icons.edit,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
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
    if (widget.event.eventName != null) {
      // just a safety check

      //get that client
      ClientSdkService clientSdkService = ClientSdkService.getInstance();

      //create a key
      AtKey atKey = AtKey();
      atKey.key = widget.event.realEvent.key.toLowerCase().replaceAll(' ', '');
      atKey.sharedWith = activeAtSign;
      atKey.sharedBy = widget.event.realEvent.atSignCreator;
      Metadata metaData = Metadata()..ccd = true;
      atKey.metadata = metaData;

      print("Deleting key:" + atKey.toString());
      //delete the key from the secondary
      bool deleteResult = await clientSdkService.delete(atKey);

      print("Delete Result:" + deleteResult.toString());

      //delete the event that exists as a invitation to someone else
      for (String invitee in widget.event.invitees) {
        //make a key again with the right sharedWith + sharedBy
        AtKey atKey = AtKey();
        atKey.key =
            widget.event.realEvent.key.toLowerCase().replaceAll(' ', '');
        atKey.sharedWith = invitee;
        atKey.sharedBy =
            widget.event.realEvent.atSignCreator.replaceAll("@", "");
        Metadata metaData = Metadata()..ccd = true;
        atKey.metadata = metaData;
        deleteResult = await clientSdkService.delete(atKey);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context)=>CalendarScreen()));
    }
  }

  _updateAndInvite() async {
    setState(() {

    });
    //create and update the event in the secondary so that the invitee added
    //is kept track of in the secondary as well
    AtKey atKey = AtKey();
    atKey.key = widget.event.realEvent.key.toLowerCase().replaceAll(" ", "");
    atKey.namespace = namespace;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = widget.event.realEvent.atSignCreator;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;

    String storedValue = EventNotificationModel.convertEventNotificationToJson(
        widget.event.realEvent);

    await ClientSdkService.getInstance().put(atKey, storedValue);

    //metadata for the shared key
    var sharedMetadata = Metadata()
      ..ccd = true
      ..ttr = 10
      ..isCached = true;
    for(String invitee in widget.event.invitees){
      //key that comes from me and is shared with the added invitee
      AtKey sharedKey = AtKey()
        ..key = atKey.key
        ..metadata = sharedMetadata
        ..sharedBy = activeAtSign
        ..sharedWith =
            invitee; //important: shared with is the person invited

      //share that key and value
      await ClientSdkService.getInstance().put(sharedKey, storedValue);
    }

  }

  //simple atSign getter
  getAtSign() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
