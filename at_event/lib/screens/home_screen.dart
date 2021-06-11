import 'package:at_event/screens/background.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:at_event/models/event.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: kPrimaryBlue),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Hello, @User",
                                style: kHeadingTextStyle,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(),
                                  child: Text(
                                      "Let's see what is happening today!",
                                      style: kNormalTextStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(8.0),
                      child: TableCalendar(
                        calendarFormat: CalendarFormat.week,
                        firstDay: DateTime(2010, 01, 01),
                        lastDay: DateTime(2050, 12, 31),
                        focusedDay: DateTime.now(),
                        onDaySelected: (selectedDay,today ){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return CalendarScreen(specificDay: selectedDay);
                          }));
                        },
                        headerStyle: HeaderStyle(
                          titleTextStyle: kHeadingTextStyle,
                          formatButtonDecoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20)),
                          formatButtonTextStyle: kNormalTextStyle,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryBlue,
                          ),
                          headerMargin: const EdgeInsets.only(bottom: 8.0),
                        ),
                        calendarStyle: CalendarStyle(
                          canMarkersOverflow: true,
                        ),
                        eventLoader: (day) {
                          List<Event> allEvents = [];
                          for (int i = 0; i < kDummyEvents.length; i++) {
                            if (kDummyEvents[i].from.day == day.day &&
                                kDummyEvents[i].from.month == day.month &&
                                kDummyEvents[i].from.year == day.year) {
                              allEvents.add(kDummyEvents[i]);
                            }
                          }
                          return allEvents;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
