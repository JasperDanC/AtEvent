import 'package:flutter/material.dart';
import 'event_datatypes.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:at_event/utils/constants.dart';

// ignore: camel_case_types
class UI_Event {
  UI_Event(
      {this.eventName = '',
      this.description = '',
      @required this.from,
      @required this.to,
      this.location,
      this.peopleGoing,
      this.category,
      this.realEvent});

  String eventName;
  DateTime from;
  DateTime to;
  String description;
  List<String> peopleGoing;
  String location;
  EventCategory category;
  EventNotificationModel realEvent;
}
