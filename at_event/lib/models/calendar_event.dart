import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:at_event/constants.dart';

class Event {
  Event({this.eventName = '', @required this.from, @required this.to});
  String eventName;
  DateTime from;
  DateTime to;
  bool isAllDay = false;
  Color background = kEventBlue;


}