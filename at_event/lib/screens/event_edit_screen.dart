import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/service/client_sdk_service.dart';
import 'package:at_commons/at_commons.dart';

void main() {
  runApp(EventEditScreen(
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
        ]),
  ));
}

class EventEditScreen extends StatefulWidget {
  EventEditScreen({this.event});
  final UI_Event event;

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  List<String> invites = [];

  int _dropDownValue;
  ClientSdkService clientSdkService;
  String _eventTitle;
  String _eventDesc;
  String _eventLocation;
  String _eventDay;
  String _eventStartTime;
  String _eventEndTime;
  EventCategory _eventCategory;
  String activeAtSign = '';

  @override
  void initState() {
    getAtSign();
    switch (widget.event.category) {
      case EventCategory.Class:
        _dropDownValue = 2;
        break;
      case EventCategory.Tutorial:
        _dropDownValue = 3;
        break;
      case EventCategory.StudySession:
        _dropDownValue = 4;
        break;
      case EventCategory.Hangout:
        _dropDownValue = 5;
        break;
      case EventCategory.Lab:
        _dropDownValue = 6;
        break;
      case EventCategory.StudentClubEvent:
        _dropDownValue = 7;
        break;
      case EventCategory.None:
        _dropDownValue = 1;
        break;
    }
    final ScrollController _scrollController = ScrollController();
    clientSdkService = ClientSdkService.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Editing event: " + widget.event.eventName,
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  onChanged: (value) {
                    _eventTitle = value;
                    setState(() {
                      widget.event.eventName = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: widget.event.eventName,
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      _eventDesc = value;
                      setState(() {
                        widget.event.description = value;
                      });
                    },
                    maxLines: 4,
                    cursorColor: Colors.white,
                    style: kEventDetailsTextStyle,
                    decoration: InputDecoration(
                      hintText: widget.event.description,
                      hintStyle: kEventDetailsTextStyle.copyWith(
                          color: Colors.grey[400]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  onChanged: (value) {
                    _eventLocation = value;
                    setState(() {
                      widget.event.location = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: widget.event.location,
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Category:",
                        style: kEventDetailsTextStyle,
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        style: kEventDetailsTextStyle,
                        dropdownColor: kBackgroundGrey,
                        onChanged: (value) {
                          _dropDownValue = value;
                        },
                        value: _dropDownValue,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              "No Category",
                            ),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Class",
                            ),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Tutorial",
                            ),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Study Session",
                            ),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Hangout",
                            ),
                            value: 5,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Lab",
                            ),
                            value: 6,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Student Club Event",
                            ),
                            value: 7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          dateMask: "MMMM dd",
                          onChanged: (dayPicked) {
                            _eventDay = dayPicked;
                          },
                          style: kEventDetailsTextStyle,
                          decoration: InputDecoration(
                            hintStyle: kEventDetailsTextStyle,
                            hintText: 'Date',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          type: DateTimePickerType.date,
                          initialDate: widget.event.to,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          onChanged: (startTimePicked) {
                            _eventStartTime = startTimePicked;
                          },
                          style: kEventDetailsTextStyle,
                          decoration: InputDecoration(
                            hintStyle: kEventDetailsTextStyle,
                            hintText: 'Start',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          type: DateTimePickerType.time,
                          initialDate: widget.event.to,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                    Text('-', style: kEventDetailsTextStyle),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          style: kEventDetailsTextStyle,
                          onChanged: (endTimePicked) {
                            _eventEndTime = endTimePicked;
                          },
                          decoration: InputDecoration(
                            labelStyle: kEventDetailsTextStyle,
                            hintStyle: kEventDetailsTextStyle,
                            hintText: 'End',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          type: DateTimePickerType.time,
                          initialDate: widget.event.from,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    _update();
                  },
                  child: Icon(Icons.check),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _update() async {
    switch (_dropDownValue) {
      case 1:
        _eventCategory = EventCategory.None;
        break;
      case 2:
        _eventCategory = EventCategory.Class;
        break;
      case 3:
        _eventCategory = EventCategory.Tutorial;
        break;
      case 4:
        _eventCategory = EventCategory.StudySession;
        break;
      case 5:
        _eventCategory = EventCategory.Hangout;
        break;
      case 6:
        _eventCategory = EventCategory.Lab;
        break;
      case 7:
        _eventCategory = EventCategory.StudentClubEvent;
        break;
      default:
        _eventCategory = EventCategory.None;
    }
    EventNotificationModel oldEventModel = widget.event.realEvent;
    Event newEvent;
    if (_eventDay == null || _eventStartTime == null || _eventEndTime == null) {
      newEvent = oldEventModel.event;
    } else {
      newEvent = Event()
        ..date = DateTime.parse(_eventDay)
        ..startTime = DateTime.parse(_eventDay + " " + _eventStartTime)
        ..endTime = DateTime.parse(_eventDay + " " + _eventEndTime);
    }

    Setting location = Setting()
      ..label = _eventLocation != null ? _eventLocation : widget.event.location;

    EventNotificationModel newEventNotification = EventNotificationModel()
      ..event = newEvent
      ..atSignCreator = oldEventModel.atSignCreator
      ..category = _eventCategory
      ..peopleGoing = oldEventModel.peopleGoing
      ..group = null
      ..title = _eventTitle != null ? _eventTitle : widget.event.eventName
      ..description = _eventDesc != null ? _eventDesc : widget.event.description
      ..setting = location
      ..key = oldEventModel.key;

    AtKey atKey = AtKey();
    atKey.key = newEventNotification.key;
    atKey.namespace = namespace;
    atKey.sharedWith = activeAtSign;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;
    print(atKey.toString());

    String storedValue = EventNotificationModel.convertEventNotificationToJson(
        newEventNotification);
    await clientSdkService.put(atKey, storedValue);

    for (String invitee in newEventNotification.invitees) {
      atKey.sharedWith = invitee;
      var operation = OperationEnum.update;
      await clientSdkService.put(atKey, storedValue);
    }

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: newEventNotification.toUIEvent(),
        ),
      ),
    );
  }

  getAtSign() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
