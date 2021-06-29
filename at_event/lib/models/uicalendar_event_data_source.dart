import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:at_event/utils/constants.dart';
import 'ui_event.dart';



class EventDataSource extends CalendarDataSource {
  EventDataSource(List<UI_Event> source){
    appointments = [];
    for(UI_Event ui_event in source){
      if(ui_event.from!= null){
        appointments.add(ui_event);
      }
    }
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return kEventBlue;
  }
}