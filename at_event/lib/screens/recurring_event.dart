import 'dart:convert';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:at_common_flutter/widgets/custom_input_field.dart';
import 'package:at_event/Widgets/custom_toast.dart';
import 'package:at_event/Widgets/custom_heading.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/service/event_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurringEvent extends StatefulWidget {
  RecurringEvent({this.EventDate});
  final EventDate;
  @override
  _RecurringEventState createState() => _RecurringEventState();
}

class _RecurringEventState extends State<RecurringEvent> {
  List<String> repeatOccurrance;
  List<String> occursOnOptions;
  bool repeatsWeekly;
  EventNotificationModel eventData;
  var occursonDate;

  @override
  void initState() {
    eventData = widget.EventDate;
    super.initState();
    repeatOccurrance = repeatOccurrenceOptions;
    occursOnOptions = occursOnWeekOptions;

    if (eventData.event.repeatCycle != null) {
      if (eventData.event.repeatCycle == RepeatCycle.MONTH) {
        repeatsWeekly = false;
      } else if (eventData.event.repeatCycle == RepeatCycle.WEEK) {
        repeatsWeekly = true;
      }
    } else {
      repeatsWeekly = false;
      eventData.event.repeatCycle = RepeatCycle.MONTH;
    }
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: Expanded(
        child: Container(
          height: SizeConfig().screenHeight * 0.8,
          decoration: BoxDecoration(
              color: kColorStyle1, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomHeading(
                  heading: 'Recurring Event',
                  action: 'Cancel',
                ),
                SizedBox(height: 25),
                Text('Repeat every',
                    style: kNormalTextStyle.copyWith(color: Colors.white)),
                SizedBox(height: 6.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomInputField(
                      width: 155.toWidth,
                      height: 50.toHeight,
                      hintText: 'repeat cycle',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      turnAppbar: true,
    );
  }
}
