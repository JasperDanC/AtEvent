import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kBackgroundGrey,
        body: SafeArea(
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

                          onPressed: (){},
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 50.0,
                          )
                      )
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
                      controller: _controller,
                      monthCellBuilder: (context, details) {
                        bool isTopLeft =
                            details.visibleDates.first == details.date;
                        bool isBottomRight =
                            details.visibleDates.last == details.date;
                        bool isTopRight =
                            details.visibleDates[6] == details.date;
                        bool isBottomLeft =
                            details.visibleDates[35] == details.date;

                        BorderRadius dateRadius = BorderRadius.only(
                          topRight:
                              isTopRight ? Radius.circular(20.0) : Radius.zero,
                          topLeft:
                              isTopLeft ? Radius.circular(20.0) : Radius.zero,
                          bottomLeft: isBottomLeft
                              ? Radius.circular(20.0)
                              : Radius.zero,
                          bottomRight: isBottomRight
                              ? Radius.circular(20.0)
                              : Radius.zero,
                        );

                        int dayIndex =
                            details.visibleDates.indexOf(details.date);

                        int lastDayOfLastMonth = 0;
                        while (
                            details.visibleDates[lastDayOfLastMonth].day != 1) {
                          lastDayOfLastMonth++;
                        }
                        lastDayOfLastMonth--;

                        int firstDayOfNextMonth = 26;
                        while (details.visibleDates[firstDayOfNextMonth].day !=
                            1) {
                          firstDayOfNextMonth++;
                        }

                        DateTime now = DateTime.now();
                        DateTime today = DateTime(now.year, now.month, now.day);

                        return Container(
                          decoration: BoxDecoration(
                            color: details.date == today
                                ? kPrimaryBlue
                                : Colors.white,
                            borderRadius: dateRadius,
                          ),
                          child: Center(
                            child: Text(
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
                      backgroundColor: _controller.view == CalendarView.month? Colors.transparent: Colors.white,
                      cellBorderColor: _controller.view == CalendarView.month? Colors.white: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
