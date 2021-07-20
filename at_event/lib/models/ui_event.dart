import 'package:flutter/material.dart';
import 'event_datatypes.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: camel_case_types
class UI_Event {
  UI_Event(
      {this.eventName = '',
      this.description = '',
      @required this.startTime,
      @required this.endTime,
      this.location,
      this.peopleGoing,
      this.invitees,
      this.category,
      this.realEvent,
      this.isRecurring}) {
    if (this.isRecurring) {
      this.startTime = realEvent.event.date;
      this.endTime = realEvent.event.endDate;
      //code to make the UI event handle recurring events
      this.recurrenceProperties =
          RecurrenceProperties(startDate: realEvent.event.date);

      if (realEvent.event.repeatCycle == RepeatCycle.MONTH) {
        recurrenceProperties.recurrenceType = RecurrenceType.monthly;
        recurrenceProperties.dayOfMonth = realEvent.event.date.day;
      }

      if (realEvent.event.repeatCycle == RepeatCycle.WEEK) {
        recurrenceProperties.recurrenceType = RecurrenceType.weekly;
        WeekDays weekDays;
        switch (realEvent.event.occursOn) {
          case Week.SUNDAY:
            weekDays = WeekDays.sunday;
            break;
          case Week.MONDAY:
            weekDays = WeekDays.monday;
            break;
          case Week.TUESDAY:
            weekDays = WeekDays.tuesday;
            break;
          case Week.WEDNESDAY:
            weekDays = WeekDays.wednesday;
            break;
          case Week.THURSDAY:
            weekDays = WeekDays.thursday;
            break;
          case Week.FRIDAY:
            weekDays = WeekDays.friday;
            break;
          case Week.SATURDAY:
            weekDays = WeekDays.saturday;
            break;
        }
        recurrenceProperties.weekDays = [weekDays];
      }

      this.recurrenceProperties.interval = realEvent.event.repeatDuration;

      RecurrenceRange range;
      switch (realEvent.event.endsOn) {
        case EndsOn.NEVER:
          range = RecurrenceRange.noEndDate;
          break;
        case EndsOn.ON:
          range = RecurrenceRange.endDate;
          this.recurrenceProperties.endDate = realEvent.event.endEventOnDate;
          break;
        case EndsOn.AFTER:
          range = RecurrenceRange.count;
          this.recurrenceProperties.recurrenceCount =
              realEvent.event.endEventAfterOccurrence;
          break;
      }

      this.recurrenceProperties.recurrenceRange = range;

      this.recurrenceRule = SfCalendar.generateRRule(
          recurrenceProperties, realEvent.event.date, realEvent.event.date);
    } else {
      recurrenceRule = '';
    }
  }
  String recurrenceRule;
  RecurrenceProperties recurrenceProperties;
  bool isRecurring;
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String description;
  List<String> peopleGoing;
  List<String> invitees;
  String location;
  EventCategory category;
  EventNotificationModel realEvent;
}
