import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:at_event/constants.dart';

class Event {
  Event({this.eventName = '',this.description = '', @required this.from, @required this.to, this.location});
  String eventName;
  DateTime from;
  DateTime to;
  String description;
  List<String> peopleGoing;
  String location;
}