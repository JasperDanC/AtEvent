import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(CalendarScreen());
}

class CalendarScreen extends StatelessWidget {
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Your Calendar",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SfCalendar(
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
                      backgroundColor: Colors.transparent,
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
