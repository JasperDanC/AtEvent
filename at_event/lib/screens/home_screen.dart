import 'package:at_event/screens/background.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:at_event/models/event.dart';
import 'package:at_event/Widgets/reusable_widgets.dart';
import '../service/client_sdk_service.dart';
import '../utils/constants.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';
import 'package:at_event/models/events_model_homescreen.dart';
import 'package:at_event/data/data_homescreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign = '';
  GlobalKey<ScaffoldState> scaffoldKey;
  List<EventTypeModel> eventsType = getEventTypes();
  List<EventsModel> events = getEvents();

  @override
  void initState() {
    getAtSign();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SafeArea(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                /// Box Decoration
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryBlue),
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
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Hello, $activeAtSign",
                                      style: kHeadingTextStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(),
                                          child: Text(
                                              "Let's see what is happening today!",
                                              style: kNormalTextStyle),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: CircleAvatar(
                                          backgroundColor: kColorStyle1,
                                          radius: 35,
                                          child: CircleAvatar(
                                            backgroundColor: kColorStyle2,
                                            radius: 30,
                                            child: CircleAvatar(
                                              backgroundColor: kColorStyle3,
                                              radius: 25,
                                              backgroundImage: AssetImage(
                                                  'assets/images/attempt.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                          margin: const EdgeInsets.all(4.0),
                          child: TableCalendar(
                            calendarFormat: CalendarFormat.week,
                            firstDay: DateTime(2010, 01, 01),
                            lastDay: DateTime(2050, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            onDaySelected: (selectedDay, today) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
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
                                color: kColorStyle1,
                              ),
                              headerMargin: const EdgeInsets.only(bottom: 6),
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
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: kSubHeadingTextStyle,
                          primary: kCategoryTile),
                      onPressed: () {
                        Navigator.pushNamed(context, '/InvitationsScreen');
                      },
                      child: Text(
                        "Event List",
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 8),
                          shrinkWrap: true,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return PopularEventTile(
                              desc: events[index].desc,
                              imgAssetPath: events[index].imgeAssetPath,
                              address: events[index].address,
                              date: events[index].date,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        turn_appbar: false);
  }

  getAtSign() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
