import 'package:at_event/models/ui_data.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/recurring_event.dart';
import 'package:at_event/screens/select_location.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_event/Widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/group_model.dart';

import 'package:at_event/widgets/custom_toast.dart';

void main() => runApp(EventCreateScreen());

// ignore: must_be_immutable
class EventCreateScreen extends StatefulWidget {
  Setting? setting;
  TextEditingController locationController = TextEditingController();
  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  List<String> invites = [];
  List<DropdownMenuItem> groupDropDownItems = [];
  Map<int, GroupModel?> groupValueMap = {0: null};
  int? _categoryDropDownValue = 1;
  int? _groupDropDownValue = 0;

  VentoService? clientSdkService;
  String? _eventTitle;
  String? _eventDesc;
  EventCategory? _eventCategory;
  String? _eventDay;
  String? _eventStartTime;
  String? _eventEndTime;
  String activeAtSign = '';

  @override
  void initState() {
    getAtSign();
    clientSdkService = VentoService.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<GroupModel> groups = Provider.of<UIData>(context).groups;
    groupDropDownItems.clear();
    groupDropDownItems.add(DropdownMenuItem(
      child: Text("No Group"),
      value: 0,
    ));
    int nextValue = 1;
    for (GroupModel g in groups) {
      if (VentoService.getInstance()
          .compareAtSigns(g.atSignCreator, activeAtSign)) {
        groupDropDownItems.add(DropdownMenuItem(
          child: Container(
            child: Text(g.title!),
            width: SizeConfig().screenWidth * 0.5,
          ),
          value: nextValue,
        ));
        groupValueMap[nextValue] = g;
        nextValue += 1;
      }
    }
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your New Event',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  maxLength: 40,
                  decoration: InputDecoration(
                    hintText: 'Event Title',
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    _eventTitle = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    cursorColor: Colors.white,
                    style: kEventDetailsTextStyle,
                    decoration: InputDecoration(
                      hintText: 'Event Description',
                      hintStyle: kEventDetailsTextStyle.copyWith(
                          color: Colors.grey[400]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onChanged: (value) {
                      _eventDesc = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  cursorColor: Colors.white,
                  controller: widget.locationController,
                  textInputAction: TextInputAction.next,
                  maxLength: 40,
                  style: kEventDetailsTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onTap: () => bottomSheet(
                      context,
                      SelectLocation(
                        createScreen: this.widget,
                      ),
                      SizeConfig().screenHeight * 0.9),
                ),
                SizedBox(
                  height: 10.0,
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
                      flex: 2,
                      child: DropdownButtonFormField(
                        dropdownColor: kBackgroundGrey,
                        style: kEventDetailsTextStyle,
                        onChanged: (dynamic value) {
                          _categoryDropDownValue = value;
                        },
                        value: _categoryDropDownValue,
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
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  flex: 2,
                    child: DropdownButtonFormField(
                  items: groupDropDownItems,
                  value: _groupDropDownValue,
                  dropdownColor: kBackgroundGrey,
                  style: kEventDetailsTextStyle,
                  onChanged: (dynamic value) {
                    setState(() {
                      _groupDropDownValue = value;
                    });
                  },
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () => bottomSheet(
                          context,
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 80,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                          type: DateTimePickerType.date,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DateTimePicker(
                                          style: kEventDetailsTextStyle,
                                          onChanged: (startTimePicked) {
                                            _eventStartTime = startTimePicked;
                                          },
                                          decoration: InputDecoration(
                                            hintStyle: kEventDetailsTextStyle,
                                            hintText: 'Start',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                          type: DateTimePickerType.time,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('-', style: kEventDetailsTextStyle),
                                  Expanded(
                                    child: Container(
                                      height: 80,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                          type: DateTimePickerType.time,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              FloatingActionButton(
                                backgroundColor: kPrimaryBlue,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _update();
                                },
                              ),
                            ],
                          ),
                          SizeConfig().screenHeight * 0.3),
                      child: Icon(Icons.add),
                    ),
                    FloatingActionButton(
                      heroTag: "Leeroy Jenkins",
                      onPressed: () {
                        createRecurring();
                      },
                      child: Icon(Icons.repeat),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _update() async {
    //goes through and makes sure every field was set to something
    bool filled = _eventTitle != null &&
        _eventTitle != "" &&
        _eventDay != null &&
        _eventDay != "" &&
        _eventStartTime != null &&
        _eventStartTime != "" &&
        _eventEndTime != null &&
        widget.setting != null &&
        _eventEndTime != "";
    if (filled) {
      //if everything was filled in
      // use this long switch statement to pick the right event event category from the dropdown value
      switch (_categoryDropDownValue) {
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
      //Create an Event Object  with correct times
      Event newEvent = Event()
        ..date = DateTime.parse(_eventDay!)
        ..startTime = DateTime.parse(_eventDay! + " " + _eventStartTime!)
        ..endTime = DateTime.parse(_eventDay! + " " + _eventEndTime!)
        ..isRecurring = false;

      //Create Location object with correct label
      // map thing will be implemented later
      Setting? location = widget.setting;

      //create the overarching summary object of everything the event will need
      EventNotificationModel newEventNotification = EventNotificationModel()
        ..event = newEvent
        ..atSignCreator = activeAtSign
        ..category = _eventCategory
        ..peopleGoing = [activeAtSign]
        ..invitees = []
        ..groupKey = _groupDropDownValue == 0
            ? ''
            : groupValueMap[_groupDropDownValue!]!.key
        ..title = _eventTitle!
        ..description = _eventDesc
        ..setting = location
        ..key = VentoService.getInstance()
            .generateKeyName(activeAtSign, KeyType.EVENT);

      Provider.of<UIData>(context, listen: false)
          .addEvent(newEventNotification.toUIEvent());

      await VentoService.getInstance()
          .createAndShareEvent(newEventNotification, activeAtSign);

      //back to the calendar
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen()),
      );
    } else {
      //if they did not fill the fields print
      CustomToast()
          .show('Please fill all fields before creating the event', context);
    }
  }

  void createRecurring() async {
    bool filled =
        _eventTitle != null && _eventTitle != "" && widget.setting != null;

    if (filled) {
      switch (_categoryDropDownValue) {
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

      Setting? location = widget.setting;

      EventNotificationModel newEventNotification = EventNotificationModel()
        ..event = Event()
        ..atSignCreator = activeAtSign
        ..category = _eventCategory
        ..peopleGoing = [activeAtSign]
        ..invitees = []
        ..groupKey = _groupDropDownValue == 0
            ? ''
            : groupValueMap[_groupDropDownValue!]!.key
        ..title = _eventTitle!
        ..description = _eventDesc
        ..setting = location
        ..key = VentoService.getInstance()
            .generateKeyName(activeAtSign, KeyType.EVENT);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RecurringEvent(eventDate: newEventNotification);
      }));
    }
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
