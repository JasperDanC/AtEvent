import 'dart:convert';
import 'package:at_contact/at_contact.dart';
import 'ui_event.dart';
import 'group_model.dart';

class EventNotificationModel {
  EventNotificationModel();
  String atSignCreator;
  bool isCancelled;
  String title;
  String description;
  Setting setting;
  GroupModel group;
  List<String> peopleGoing;
  List<String> invitees;
  EventCategory category;
  Event event;
  String key;
  bool isSharing;
  bool
      isUpdating; // This becomes true when event data is being updated, should be true
  EventNotificationModel.fromJson(Map<String, dynamic> data) {
    title = data['title'] ?? '';
    key = data['key'] ?? '';
    String stringCategory = data['category'] ?? '';
    switch(stringCategory){
      case 'EventCategory.None':
        category = EventCategory.None;
        break;
      case 'EventCategory.Class':
        category = EventCategory.Class;
        break;
      case 'EventCategory.Hangout':
        category= EventCategory.Hangout;
        break;
      case 'EventCategory.Lab':
        category = EventCategory.Lab;
        break;
      case 'EventCategory.Tutorial':
        category = EventCategory.Tutorial;
        break;
      case 'EventCategory.StudentClubEvent':
        category = EventCategory.StudentClubEvent;
    }
    description = data['description'] ?? '';
    peopleGoing = data['peopleGoing'] == '[]' || data['peopleGoing'] == ''
        ? []
        : data['peopleGoing'].split(',') ?? [];

    invitees = data['invitees'] == '[]' || data['invitees'] == '' ? [] : data['invitees'].split(',') ?? [];
    atSignCreator = data['atSignCreator' ?? ''];
    isCancelled = data['isCancelled'] == 'true' ? true : false;
    isSharing = data['isSharing'] == 'true' ? true : false;
    isUpdating = data['isUpdating'] == 'true' ? true : false;
    if (data['setting'] != 'null' && data['setting'] != null) {
      setting = Setting.fromJson(jsonDecode(data['setting']));
    }
    if (data['event'] != 'null' && data['event'] != null) {
      event = data['event'] != null
          ? Event.fromJson(jsonDecode(data['event']))
          : 'null';
    }
    if (data['group'] != 'null' && data['group'] != null) {
      group = GroupModel.fromJson(jsonDecode(data['group']));
    }
  }

  static String convertEventNotificationToJson(
      EventNotificationModel eventNotification) {
    var notification = json.encode({
      'title': eventNotification.title != null
          ? eventNotification.title.toString()
          : '',
      'isCancelled': eventNotification.isCancelled.toString(),
      'isSharing': eventNotification.isSharing.toString(),
      'description': eventNotification.description,

      'invitees' : eventNotification.invitees.length > 0 ?eventNotification.invitees.join(',') : '[]',
      'peopleGoing': eventNotification.peopleGoing.length > 0
          ? eventNotification.peopleGoing.join(',')
          : '[]',
      'isUpdate': eventNotification.isUpdating.toString(),
      'atSignCreator': eventNotification.atSignCreator.toString(),
      'category': eventNotification.category.toString(),
      'key': '${eventNotification.key}',
      'group': eventNotification.group!= null? GroupModel.convertGroupToJson(eventNotification.group): 'null',
      'setting': json.encode({
        'latitude': eventNotification.setting.latitude.toString(),
        'longitude': eventNotification.setting.longitude.toString(),
        'label': eventNotification.setting.label
      }),
      'event': json.encode({
        'isRecurring': eventNotification.event.isRecurring.toString(),
        'date': eventNotification.event.date.toString(),
        'endDate': eventNotification.event.endDate.toString(),
        'startTime': eventNotification.event.startTime != null
            ? eventNotification.event.startTime.toUtc().toString()
            : null,
        'endTime': eventNotification.event.endTime != null
            ? eventNotification.event.endTime.toUtc().toString()
            : null,
        'repeatDuration': eventNotification.event.repeatDuration.toString(),
        'repeatCycle': eventNotification.event.repeatCycle.toString(),
        'occursOn': eventNotification.event.occursOn.toString(),
        'endsOn': eventNotification.event.endsOn.toString(),
        'endEventOnDate': eventNotification.event.endEventOnDate.toString(),
        'endEventAfterOccurance':
            eventNotification.event.endEventAfterOccurrence.toString()
      }),
    });
    return notification;
  }

  UI_Event toUI_Event() {
    UI_Event ui_event = UI_Event(
      eventName: this.title,
      category: this.category,
      description: this.description,
      location: this.setting.label,
      peopleGoing: this.peopleGoing,
      invitees: this.invitees,
      from: event.startTime,
      to: event.endTime,
      isRecurring: this.event.isRecurring,
      realEvent: this,
    );

    return ui_event;
  }
}

class Setting {
  Setting();
  double latitude, longitude;
  String label;
  Setting.fromJson(Map<String, dynamic> data)
      : latitude =
            data['latitude'] != 'null' ? double.parse(data['latitude']) : 0,
        longitude =
            data['longitude'] != 'null' ? double.parse(data['longitude']) : 0,
        label = data['label'] != 'null' ? data['label'] : '';
}

enum EventCategory {
  Class,
  Tutorial,
  StudySession,
  Hangout,
  Lab,
  StudentClubEvent,
  None,
}

class Event {
  Event();

  bool isRecurring;
  DateTime date, endDate;
  DateTime startTime, endTime; // one day event
  int repeatDuration;
  RepeatCycle repeatCycle;
  Week occursOn;
  EndsOn endsOn;
  DateTime endEventOnDate;
  int endEventAfterOccurrence;

  Event.fromJson(Map<String, dynamic> data) {
    startTime = data['startTime'] != null
        ? DateTime.parse(data['startTime']).toLocal()
        : null;
    endTime = data['endTime'] != null
        ? DateTime.parse(data['endTime']).toLocal()
        : null;
    isRecurring = data['isRecurring'] == 'true' ? true : false;
    if (!isRecurring) {
      date = data['date'] != 'null' ? DateTime.parse(data['date']) : null;
      endDate =
          data['endDate'] != 'null' ? DateTime.parse(data['endDate']) : null;
    } else {
      date = data['date'] != 'null' ? DateTime.parse(data['date']) : null;
      endDate =
      data['endDate'] != 'null' ? DateTime.parse(data['endDate']) : null;
      repeatDuration = data['repeatDuration'] != 'null'
          ? int.parse(data['repeatDuration'])
          : null;
      repeatCycle = (data['repeatCycle'] == RepeatCycle.WEEK.toString()
          ? RepeatCycle.WEEK
          : (data['repeatCycle'] == RepeatCycle.MONTH.toString()
              ? RepeatCycle.MONTH
              : null));
      switch (repeatCycle) {
        case RepeatCycle.WEEK:
          occursOn = (data['occursOn'] == Week.SUNDAY.toString()
              ? Week.SUNDAY
              : (data['occursOn'] == Week.MONDAY.toString()
                  ? Week.MONDAY
                  : (data['occursOn'] == Week.TUESDAY.toString()
                      ? Week.TUESDAY
                      : (data['occursOn'] == Week.WEDNESDAY.toString()
                          ? Week.WEDNESDAY
                          : (data['occursOn'] == Week.THURSDAY.toString()
                              ? Week.THURSDAY
                              : (data['occursOn'] == Week.FRIDAY.toString()
                                  ? Week.FRIDAY
                                  : (data['occursOn'] ==
                                          Week.SATURDAY.toString()
                                      ? Week.SATURDAY
                                      : null)))))));
          break;
        case RepeatCycle.MONTH:
          date = data['date'] != 'null' ? DateTime.parse(data['date']) : null;
          break;
      }
      endsOn = (data['endsOn'] == EndsOn.NEVER.toString()
          ? EndsOn.NEVER
          : (data['endsOn'] == EndsOn.ON.toString()
              ? EndsOn.ON
              : (data['endsOn'] == EndsOn.AFTER.toString()
                  ? EndsOn.AFTER
                  : null)));
      switch (endsOn) {
        case EndsOn.ON:
          endEventOnDate = data['endEventOnDate'] != 'null'
              ? DateTime.parse(data['endEventOnDate'])
              : null;
          break;
        case EndsOn.AFTER:
          endEventAfterOccurrence = data['endEventAfterOccurance'] != 'null'
              ? int.parse(data['endEventAfterOccurance'])
              : null;
          break;
        case EndsOn.NEVER:
          // endEventOn = null;
          break;
      }
    }
  }
}

enum RepeatCycle { WEEK, MONTH }
enum Week { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }
enum EndsOn { NEVER, ON, AFTER }

Week getWeekEnum(String weekday) {
  switch (weekday) {
    case 'Monday':
      return Week.MONDAY;
    case 'Tuesday':
      return Week.TUESDAY;
    case 'Wednesday':
      return Week.WEDNESDAY;
    case 'Thursday':
      return Week.THURSDAY;
    case 'Friday':
      return Week.FRIDAY;
    case 'Saturday':
      return Week.SATURDAY;
    case 'Sunday':
      return Week.SUNDAY;
  }
  return null;
}

String getWeekString(Week weekday) {
  switch (weekday) {
    case Week.MONDAY:
      return 'Monday';
    case Week.TUESDAY:
      return 'Tuesday';
    case Week.WEDNESDAY:
      return 'Wednesday';
    case Week.THURSDAY:
      return 'Thursday';
    case Week.FRIDAY:
      return 'Friday';
    case Week.SATURDAY:
      return 'Saturday';
    case Week.SUNDAY:
      return 'Sunday';
  }
  return null;
}

String timeOfDayToString(DateTime time) {
  var hrmin = '${time.hour}:${time.minute}';
  return hrmin;
}

String dateToString(DateTime date) {
  var dateString = '${date.day}/${date.month}/${date.year}';
  return dateString;
}

List<String> get repeatOccurrenceOptions => ['Week', 'Month'];
List<String> get occursOnWeekOptions => [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

enum ATKEY_TYPE_ENUM { CREATEEVENT, ACKNOWLEDGEEVENT }
