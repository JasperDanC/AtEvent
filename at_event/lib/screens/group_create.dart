import 'package:at_event/models/ui_data.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/recurring_event.dart';
import 'package:at_event/screens/select_location.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_event/widgets/bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:at_event/widgets/category_selector.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/service/client_sdk_service.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/group_model.dart';

import 'package:at_event/widgets/custom_toast.dart';

void main() => runApp(GroupCreateScreen());

class GroupCreateScreen extends StatefulWidget {
  @override
  _GroupCreateScreenState createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  List<String> invites = [];
  int _dropDownValue = 1;

  final ScrollController _scrollController = ScrollController();
  ClientSdkService clientSdkService;
  String _groupTitle;
  String _groupDesc;
  List<String> _invitees;
  String activeAtSign = '';

  TextEditingController _inviteTextController;

  @override
  void initState() {
    getAtSign();
    clientSdkService = ClientSdkService.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: kColorStyle2, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your New Group',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Group Title',
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    _groupTitle = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    cursorColor: Colors.white,
                    style: kEventDetailsTextStyle,
                    decoration: InputDecoration(
                      hintText: 'Group Description',
                      hintStyle: kEventDetailsTextStyle.copyWith(
                          color: Colors.grey[400]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onChanged: (value) {
                      _groupDesc = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      onPressed: () {
                        _invitees.add(_inviteTextController.value.toString());
                        _inviteTextController.clear();
                      },
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    Text(
                      '@',
                      style: TextStyle(color: Color(0xFFaae5e6), fontSize: 22),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inviteTextController,
                        cursorColor: Colors.white,
                        style: kEventDetailsTextStyle,
                        decoration: InputDecoration(
                          hintStyle: kEventDetailsTextStyle.copyWith(
                              color: Colors.grey[400]),
                          hintText: 'signs to add to group',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: kForegroundGrey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12.0),
                            controller: _scrollController,
                            itemCount: invites.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  invites[index],
                                  style: kEventDetailsTextStyle,
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _update() async {
    //goes through and makes sure every field was set to something
    bool filled = _groupTitle != null &&
        _groupTitle != "" &&
        _groupDesc != null &&
        _groupDesc != "";
    if (filled) {

      GroupModel group = GroupModel()
      ..atSignCreator = activeAtSign
      ..key = 'group_'+_groupTitle
      ..title = _groupTitle
      ..description = _groupDesc
      ..invitees = _invitees
      ..atSignMembers = [activeAtSign]
      ..eventKeys = []



      //create the @key
      AtKey atKey = AtKey();
      atKey.key = newEventNotification.key;
      atKey.sharedWith = activeAtSign;
      atKey.sharedBy = activeAtSign;
      Metadata metadata = Metadata();
      metadata.ccd = true;
      atKey.metadata = metadata;
      print(atKey.toString());

      //set the value to store in the secondary as the json version of the EventNotifications object
      String storedValue =
          EventNotificationModel.convertEventNotificationToJson(
              newEventNotification);

      //put that shiza on the secondary
      await clientSdkService.put(atKey, storedValue);
      Provider.of<UIData>(context, listen: false)
          .addEvent(newEventNotification.toUI_Event());
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

  void createRecurring() {
    bool filled =
        _groupTitle != null && _groupTitle != "" && widget.setting != null;

    if (filled) {
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

      Setting location = widget.setting;

      EventNotificationModel newEventNotification = EventNotificationModel()
        ..event = Event()
        ..atSignCreator = activeAtSign
        ..category = _eventCategory
        ..peopleGoing = [activeAtSign]
        ..invitees = []
        ..group = null
        ..title = _groupTitle
        ..description = _groupDesc
        ..setting = location
        ..key = "event " + _groupTitle;

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RecurringEvent(eventDate: newEventNotification);
      }));
    }
  }

  getAtSign() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
