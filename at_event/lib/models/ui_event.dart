import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:at_event/utils/constants.dart';

// ignore: camel_case_types
class UI_Event {
  UI_Event({this.eventName = '',this.description = '', @required this.from, @required this.to, this.location, this.peopleGoing, this.category});
  String eventName;
  DateTime from;
  DateTime to;
  String description;
  List<String> peopleGoing;
  String location;
  String category;
}