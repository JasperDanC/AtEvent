import 'package:at_event/screens/background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:at_event/widgets/category_selector.dart';


void main() => runApp(EventCreateScreen());

class EventCreateScreen extends StatefulWidget {
  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  List<String> invites = [];
  int _dropDownValue = 1;


  final ScrollController _scrollController = ScrollController();
  String _eventTitle;
  String _eventDesc;
  String _eventLocation;
  Category _eventCategory;
  List<String> _invitees;
  DateTime _eventStart;
  DateTime _eventFrom;

  TextEditingController _inviteTextController;


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
              children: [
                Text(
                  'Your New Event',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,

                  decoration: InputDecoration(
                    hintText: 'Event Title',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value){
                    _eventTitle = value;
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
                      hintText: 'Event Description',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onChanged: (value){
                      _eventDesc = value;
                    },
                  ),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    _eventLocation = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                CategoryDropDown(dropDownValue: _dropDownValue),
                SizedBox(
                  height: 10,
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
                          hintText: 'signs to invite',
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
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          dateMask: "MMMM dd",
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
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
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
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                    Text('-', style: kEventDetailsTextStyle),
                    Container(
                      width: 100,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          style: kEventDetailsTextStyle,
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
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.add),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
