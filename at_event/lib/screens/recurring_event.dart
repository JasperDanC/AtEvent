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
  RecurringEvent({this.eventDate});
  final eventDate;
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
    eventData = widget.eventDate;
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
                      icon: Icons.keyboard_arrow_down,
                      initialValue: eventData.event.repeatDuration != null
                          ? eventData.event.repeatDuration.toString()
                          : '',
                      value: (val) {
                        if (val.trim().isNotEmpty) {
                          var repeatCycle = int.parse(val);
                          eventData.event.repeatDuration = repeatCycle;
                        } else {
                          eventData.event.repeatDuration = null;
                        }
                        print('repeat cycle:${eventData.event.repeatDuration}');
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      width: 155.toWidth,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          underline: SizedBox(),
                          elevation: 0,
                          dropdownColor: kBackgroundGrey,
                          value: (eventData.event.repeatCycle != null)
                              ? eventData.event.repeatCycle == RepeatCycle.WEEK
                                  ? 'Week'
                                  : eventData.event.repeatCycle ==
                                          RepeatCycle.MONTH
                                      ? 'Month'
                                      : null
                              : null,
                          hint: Text('Select Category'),
                          items: repeatOccurrance.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String selectedOption) {
                            switch (selectedOption) {
                              case 'Week':
                                eventData.event.repeatCycle = RepeatCycle.WEEK;
                                repeatsWeekly = true;
                                break;

                              case 'Month':
                                eventData.event.repeatCycle = RepeatCycle.MONTH;
                                repeatsWeekly = false;
                                break;
                            }
                            setState(() {});
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 25.toHeight),
                Text('Occurs on', style: kNormalTextStyle),
                SizedBox(height: 6.toHeight),
                repeatsWeekly
                    ? Container(
                        color: kBackgroundGrey,
                        width: 350.toWidth,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            underline: SizedBox(),
                            elevation: 0,
                            dropdownColor: kBackgroundGrey,
                            value: eventData.event.occursOn != null
                                ? getWeekString(eventData.event.occursOn)
                                : null,
                            hint: Text('Occurs on'),
                            items: occursOnOptions.map(
                              (String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              },
                            ).toList(),
                            onChanged: (String selectedOption) {
                              var weekday = getWeekEnum(selectedOption);
                              if (weekday != null) {
                                eventData.event.occursOn = weekday;
                              }

                              print(eventData.event.occursOn);

                              setState(() {});
                            }))
                    : CustomInputField(
                        width: 350.toWidth,
                        height: 50.toHeight,
                        isReadOnly: true,
                        hintText: 'Occurs on',
                        icon: Icons.access_time,
                        initialValue: eventData.event.date != null
                            ? dateToString(eventData.event.date)
                            : '',
                        onTap: () async {
                          final datePicked = await showDatePicker(
                            context: context,
                            initialDate: (eventData.event.date != null)
                                ? eventData.event.date
                                : DateTime.now(),
                            firstDate: DateTime(2001, 1),
                            lastDate: DateTime(2101),
                          );

                          if (datePicked != null) {
                            eventData.event.date = datePicked;
                            setState(() {});
                          }
                        },
                        value: (val) {},
                      ),
                SizedBox(height: 25.toHeight),
                Text('Select a time', style: kNormalTextStyle),
                SizedBox(height: 25.toHeight),
                SizedBox(height: 6.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomInputField(
                      width: 155.toWidth,
                      height: 50.toHeight,
                      isReadOnly: true,
                      hintText: 'Start',
                      icon: Icons.access_time,
                      initialValue: eventData.event.startTime != null
                          ? timeOfDayToString(eventData.event.startTime)
                          : '',
                      onTap: () async {
                        final timePicked = await showTimePicker(
                            context: context,
                            initialTime: eventData.event.startTime != null
                                ? TimeOfDay.fromDateTime(
                                    eventData.event.startTime)
                                : TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.input);

                        if (eventData.event.date == null) {
                          eventData.event.date = DateTime(
                              eventData.event.date.year,
                              eventData.event.date.month,
                              eventData.event.date.day,
                              timePicked.hour,
                              timePicked.minute);
                          setState(() {});
                        }
                      },
                    ),
                    CustomInputField(
                      width: 155.toWidth,
                      height: 50.toHeight,
                      isReadOnly: true,
                      hintText: 'Stop',
                      icon: Icons.access_time,
                      initialValue: eventData.event.endTime != null
                          ? timeOfDayToString(eventData.event.endTime)
                          : '',
                      onTap: () async {
                        final timePicked = await showTimePicker(
                            context: context,
                            initialTime: eventData.event.endTime != null
                                ? TimeOfDay.fromDateTime(
                                    eventData.event.endTime)
                                : TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.input);

                        if (eventData.event.endDate == null) {
                          CustomToast()
                              .show('Select start time first', context);
                          return;
                        }
                        if (timePicked != null) {
                          eventData.event.endTime = DateTime(
                              eventData.event.date.year,
                              eventData.event.date.month,
                              eventData.event.date.day,
                              timePicked.hour,
                              timePicked.minute);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 25.toHeight),
                Text('Ends On', style: kNormalTextStyle),
                SizedBox(height: 25.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Never',
                        style: kNormalTextStyle.copyWith(fontSize: 12)),
                    Radio(
                      groupValue: eventData.event.endsOn,
                      toggleable: true,
                      value: EndsOn.ON,
                      onChanged: (value) {
                        eventData.event.endsOn = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 6.toHeight),
                CustomInputField(
                  width: 350.toWidth,
                  height: 50.toHeight,
                  isReadOnly: true,
                  hintText: 'Select Date',
                  icon: Icons.date_range,
                  initialValue: (eventData.event.endEventOnDate != null)
                      ? dateToString(eventData.event.endEventOnDate)
                      : '',
                  onTap: () async {
                    final datePicked = await showDatePicker(
                      context: context,
                      initialDate:
                          eventData.event.endEventOnDate ?? DateTime.now(),
                      firstDate: DateTime(2001, 1),
                      lastDate: DateTime(2101),
                    );

                    if (datePicked != null) {
                      eventData.event.endEventOnDate = datePicked;
                      setState(() {});
                    }
                  },
                  value: (value) {},
                ),
                SizedBox(height: 6.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('After',
                        style: kNormalTextStyle.copyWith(fontSize: 12)),
                    Radio(
                      groupValue: eventData.event.endsOn,
                      toggleable: true,
                      value: EndsOn.AFTER,
                      onChanged: (value) {
                        eventData.event.endsOn = value;

                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.toHeight,
                ),
                CustomInputField(
                    width: 350.toWidth,
                    height: 50.toHeight,
                    hintText: 'Start',
                    initialValue:
                        eventData.event.endEventAfterOccurrence != null
                            ? eventData.event.endEventAfterOccurrence.toString()
                            : '',
                    value: (val) {
                      if (val.trim().isNotEmpty) {
                        var occurrence = int.parse(val);
                        eventData.event.endEventAfterOccurrence = occurrence;
                      }
                    }),
                SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    onPressed: () {
                      // TODO: Implement a confirmation request that will update our event to become a recurring event
                      // For now it will just pop back to the other screen.
                      Navigator.of(context).pop();
                    },
                    buttonText: 'Done',
                    width: 164.toWidth,
                    height: 48.toHeight,
                    buttonColor: kColorStyle2,
                    fontColor: Colors.white,
                  ),
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
