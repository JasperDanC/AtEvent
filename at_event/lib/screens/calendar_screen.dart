import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:at_event/models/event.dart';
import 'package:at_event/models/calendar_event_data_source.dart';

void main() {
  runApp(CalendarScreen());
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController _controller = CalendarController();
  int switchIndex = 0;

  EventDataSource _getEventData() {
    List<Event> dummyEvents = [
      Event(
          eventName: "Test Event 1",
          from: DateTime(2021, 06, 09, 6),
          to: DateTime(2021, 06, 09, 9)),
      Event(
          eventName: "Test Event 2",
          from: DateTime(2021, 06, 10, 18),
          to: DateTime(2021, 06, 10, 21)),
      Event(
          eventName: "Test Event 3",
          from: DateTime(2021, 06, 14, 10),
          to: DateTime(2021, 06, 14, 11)),
      Event(
          eventName: "Test Event 4",
          from: DateTime(2021, 06, 22, 6),
          to: DateTime(2021, 06, 22, 9)),
    ];
    return EventDataSource(dummyEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kPrimaryBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 55,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Calendar",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {},
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 50.0,
                        ))
                  ],
                ),
                ToggleSwitch(
                  totalSwitches: 3,
                  labels: ["Month", "Week", "Day"],
                  initialLabelIndex: switchIndex,
                  onToggle: (index) {
                    setState(() {
                      switchIndex = index;
                      switch (index) {
                        case 0:
                          {
                            _controller.view = CalendarView.month;
                          }
                          break;
                        case 1:
                          {
                            _controller.view = CalendarView.week;
                          }
                          break;
                        case 2:
                          {
                            _controller.view = CalendarView.day;
                          }
                          break;
                      }
                    });
                  },
                ),
                Expanded(
                  child: SfCalendar(
                    onTap: (CalendarTapDetails ctd){
                      if(switchIndex == 0) {
                        setState(() {
                          switchIndex = 2;
                          _controller.view = CalendarView.day;
                        });
                      } else {
                        if(ctd.appointments.length != null){

                        }
                      }
                    },
                    dataSource: _getEventData(),
                    controller: _controller,
                    monthCellBuilder: (context, details) {
                      bool isTopLeft = details.visibleDates.first == details.date;
                      bool isBottomRight =
                          details.visibleDates.last == details.date;
                      bool isTopRight = details.visibleDates[6] == details.date;
                      bool isBottomLeft =
                          details.visibleDates[35] == details.date;

                      BorderRadius dateRadius = BorderRadius.only(
                        topRight:
                            isTopRight ? Radius.circular(20.0) : Radius.zero,
                        topLeft: isTopLeft ? Radius.circular(20.0) : Radius.zero,
                        bottomLeft:
                            isBottomLeft ? Radius.circular(20.0) : Radius.zero,
                        bottomRight:
                            isBottomRight ? Radius.circular(20.0) : Radius.zero,
                      );

                      int dayIndex = details.visibleDates.indexOf(details.date);

                      int lastDayOfLastMonth = 0;
                      while (details.visibleDates[lastDayOfLastMonth].day != 1) {
                        lastDayOfLastMonth++;
                      }
                      lastDayOfLastMonth--;

                      int firstDayOfNextMonth = 26;
                      while (details.visibleDates[firstDayOfNextMonth].day != 1) {
                        firstDayOfNextMonth++;
                      }

                      DateTime now = DateTime.now();
                      DateTime today = DateTime(now.year, now.month, now.day);

                      return Container(
                        decoration: BoxDecoration(
                          color:
                              details.date == today ? kPrimaryBlue : Colors.white,
                          borderRadius: dateRadius,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                details.date.day.toString(),
                                style: details.date == today
                                    ? TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      )
                                    : TextStyle(
                                        color: lastDayOfLastMonth < dayIndex &&
                                                dayIndex < firstDayOfNextMonth
                                            ? Colors.black
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                              CircleAvatar(
                                backgroundColor: kEventBlue,
                                radius: details.appointments.length != 0 ? 15 : 0,
                                child: Text(
                                  details.appointments.length != 0
                                      ? details.appointments.length.toString()
                                      : "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    headerStyle: CalendarHeaderStyle(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        backgroundColor: kPrimaryBlue),
                    viewHeaderStyle: ViewHeaderStyle(
                        dayTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        backgroundColor: kPrimaryBlue),
                    view: CalendarView.month,
                    backgroundColor: _controller.view == CalendarView.month
                        ? Colors.transparent
                        : Colors.white,
                    cellBorderColor: _controller.view == CalendarView.month
                        ? Colors.white
                        : Colors.grey[110],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
