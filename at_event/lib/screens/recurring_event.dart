import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:at_common_flutter/widgets/custom_input_field.dart';
import '../Widgets/custom_toast.dart';
import 'package:at_event/Widgets/custom_heading.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/service/vento_services.dart';
import 'calendar_screen.dart';
import 'package:provider/provider.dart';

class RecurringEvent extends StatefulWidget {
  RecurringEvent({this.eventDate});
  final EventNotificationModel? eventDate;
  @override
  _RecurringEventState createState() => _RecurringEventState();
}

class _RecurringEventState extends State<RecurringEvent> {
  VentoService? clientSdkService;
  late List<String> repeatOccurrance;
  late List<String> occursOnOptions;
  String activeAtSign = '';
  late bool repeatsWeekly;
  EventNotificationModel? eventData;
  var occursonDate;
  TextEditingController startTimeController = TextEditingController();

  @override
  void initState() {
    getAtSign();
    clientSdkService = VentoService.getInstance();
    eventData = widget.eventDate;
    eventData!.event.isRecurring = true;

    super.initState();
    repeatOccurrance = repeatOccurrenceOptions;
    occursOnOptions = occursOnWeekOptions;
    if (eventData!.event.repeatCycle != null) {
      if (eventData!.event.repeatCycle == RepeatCycle.MONTH) {
        repeatsWeekly = false;
      } else if (eventData!.event.repeatCycle == RepeatCycle.WEEK) {
        repeatsWeekly = true;
      }
    } else {
      repeatsWeekly = false;
      eventData!.event.repeatCycle = RepeatCycle.MONTH;
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 25),
                Text('Repeat every',
                    style: kNormalTextStyle.copyWith(color: Colors.white)),
                SizedBox(height: 6.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                          value: (eventData!.event.repeatCycle != null)
                              ? eventData!.event.repeatCycle == RepeatCycle.WEEK
                                  ? 'Week'
                                  : eventData!.event.repeatCycle ==
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
                          onChanged: (String? selectedOption) {
                            switch (selectedOption) {
                              case 'Week':
                                eventData!.event.repeatCycle = RepeatCycle.WEEK;
                                eventData!.event.date = DateTime.now();
                                repeatsWeekly = true;
                                break;

                              case 'Month':
                                eventData!.event.repeatCycle =
                                    RepeatCycle.MONTH;
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
                            value: eventData!.event.occursOn != null
                                ? getWeekString(eventData!.event.occursOn)
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
                            onChanged: (String? selectedOption) {
                              var weekday = getWeekEnum(selectedOption);
                              if (weekday != null) {
                                eventData!.event.occursOn = weekday;
                              }

                              print(eventData!.event.occursOn);

                              setState(() {});
                            }))
                    : CustomInputField(
                        width: 350.toWidth,
                        height: 50.toHeight,
                        isReadOnly: true,
                        hintText: 'Occurs on',
                        icon: Icons.access_time,
                        initialValue: eventData!.event.date != null
                            ? dateToString(eventData!.event.date!)
                            : '',
                        onTap: () async {
                          final datePicked = await showDatePicker(
                            context: context,
                            initialDate: (eventData!.event.date != null)
                                ? eventData!.event.date!
                                : DateTime.now(),
                            firstDate: DateTime(2001, 1),
                            lastDate: DateTime(2101),
                          );

                          if (datePicked != null) {
                            setState(() {
                              eventData!.event.date = datePicked;
                            });
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
                    InputField(
                      width: 155.toWidth,
                      height: 50.toHeight,
                      isReadOnly: true,
                      hintText: 'Start',
                      controller: startTimeController,
                      icon: Icons.access_time,
                      initialValue: eventData!.event.date != null
                          ? timeOfDayToString(eventData!.event.date!)
                          : '',
                      value: (value) =>
                          timeOfDayToString(eventData!.event.date!),
                      onTap: () async {
                        print("opened picker");
                        final timePicked = await showTimePicker(
                            context: context,
                            initialTime: widget.eventDate!.event.date != null
                                ? TimeOfDay.fromDateTime(eventData!.event.date!)
                                : TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.input);

                        if (timePicked != null) {
                          print("time picked not null");

                          setState(() {
                            widget.eventDate!.event.date = DateTime(
                                eventData!.event.date!.year,
                                eventData!.event.date!.month,
                                eventData!.event.date!.day,
                                timePicked.hour,
                                timePicked.minute);
                            print(timeOfDayToString(eventData!.event.date!));
                          });
                        }
                      },
                    ),
                    CustomInputField(
                      width: 155.toWidth,
                      height: 50.toHeight,
                      isReadOnly: true,
                      hintText: 'Stop',
                      icon: Icons.access_time,
                      initialValue: eventData!.event.endDate != null
                          ? timeOfDayToString(eventData!.event.endDate!)
                          : '',
                      value: (value) =>
                          timeOfDayToString(eventData!.event.endDate!),
                      onTap: () async {
                        final timePicked = await showTimePicker(
                            context: context,
                            initialTime: eventData!.event.endDate != null
                                ? TimeOfDay.fromDateTime(
                                    eventData!.event.endDate!)
                                : TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.input);

                        if (eventData!.event.date == null) {
                          CustomToast()
                              .show('Select start time first', context);
                          return;
                        }
                        if (timePicked != null) {
                          setState(() {
                            eventData!.event.endDate = DateTime(
                                eventData!.event.date!.year,
                                eventData!.event.date!.month,
                                eventData!.event.date!.day,
                                timePicked.hour,
                                timePicked.minute);
                          });
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
                    Text('After A Specific Day ',
                        style: kNormalTextStyle.copyWith(fontSize: 12)),
                    Radio(
                      groupValue: eventData!.event.endsOn,
                      toggleable: true,
                      value: EndsOn.ON,
                      onChanged: (dynamic value) {
                        eventData!.event.endsOn = value;
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
                  initialValue: (eventData!.event.endEventOnDate != null)
                      ? dateToString(eventData!.event.endEventOnDate!)
                      : '',
                  onTap: () async {
                    final datePicked = await showDatePicker(
                      context: context,
                      initialDate:
                          eventData!.event.endEventOnDate ?? DateTime.now(),
                      firstDate: DateTime(2001, 1),
                      lastDate: DateTime(2101),
                    );

                    if (datePicked != null) {
                      eventData!.event.endEventOnDate = datePicked;
                      setState(() {});
                    }
                  },
                  value: (value) {},
                ),
                SizedBox(height: 6.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('After a Number of Times',
                        style: kNormalTextStyle.copyWith(fontSize: 12)),
                    Radio(
                      groupValue: eventData!.event.endsOn,
                      toggleable: true,
                      value: EndsOn.AFTER,
                      onChanged: (dynamic value) {
                        eventData!.event.endsOn = value;

                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.toHeight,
                ),
                InputField(
                    width: 350.toWidth,
                    height: 50.toHeight,
                    hintText: 'Amount of Times Event Occurs',
                    keyStyle: TextInputType.number,
                    initialValue: eventData!.event.endEventAfterOccurrence !=
                            null
                        ? eventData!.event.endEventAfterOccurrence.toString()
                        : '',
                    value: (val) {
                      if (val.trim().isNotEmpty) {
                        var occurrence = int.parse(val);
                        eventData!.event.endEventAfterOccurrence = occurrence;
                      }
                    }),
                SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    onPressed: () {
                      _update();
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

  _update() async {
    //goes through and makes sure every field was set to something
    bool filled = widget.eventDate!.event != null ||
        widget.eventDate!.event.startTime != null ||
        widget.eventDate!.event.endTime != null;

    if (widget.eventDate!.event.repeatCycle == RepeatCycle.WEEK) {
      filled = filled && widget.eventDate!.event.occursOn != null;
    } else if (widget.eventDate!.event.repeatCycle == RepeatCycle.MONTH) {
      filled = filled && widget.eventDate!.event.date != null;
    } else {
      filled = false;
    }

    if (widget.eventDate!.event.endsOn == null) {
      widget.eventDate!.event.endsOn = EndsOn.NEVER;
    } else if (widget.eventDate!.event.endsOn == EndsOn.ON) {
      filled = filled && widget.eventDate!.event.endEventOnDate != null;
    } else if (widget.eventDate!.event.endsOn == EndsOn.AFTER) {
      filled =
          filled && widget.eventDate!.event.endEventAfterOccurrence != null;
    }
    if (filled) {
      if (widget.eventDate!.event.endsOn == null) {
        widget.eventDate!.event.endsOn = EndsOn.NEVER;
      }
      widget.eventDate!.event.repeatDuration = 1;

      Provider.of<UIData>(context, listen: false)
          .addEvent(widget.eventDate!.toUIEvent());
      await VentoService.getInstance()
          .createAndShareEvent(widget.eventDate!, activeAtSign);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CalendarScreen()));
    } else {
      //if they did not fill the fields print
      CustomToast()
          .show('Please fill all fields before creating the event', context);
    }
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
