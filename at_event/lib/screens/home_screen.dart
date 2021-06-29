import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/Widgets/event_tiles.dart';
import '../service/client_sdk_service.dart';
import '../utils/constants.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';
import 'package:at_event/models/events_model_homescreen.dart';
import 'package:at_event/data/data_homescreen.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import 'package:at_event/Widgets/circle_avatar.dart';
import 'package:at_event/utils/functions.dart';

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
    getAtSignAndInitContacts();
    scan();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return MaterialApp(
        home: Scaffold(
      backgroundColor: kBackgroundGrey,
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Your Invitations"),
              onTap: () {
                Navigator.pushNamed(context, '/InvitationsScreen');
              },
            ),
            ListTile(
              title: Text("Contacts"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContactsScreen(),
                ));
              },
            ),
            ListTile(
              title: Text("Blocked"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BlockedScreen(),
                ));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          /// Box Decoration
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Hello, $activeAtSign",
                                    style: kHeadingTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                MaterialButton(
                                  padding: EdgeInsets.zero,
                                  shape: CircleBorder(),
                                  onPressed: () {
                                    scaffoldKey.currentState.openDrawer();
                                  },
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                      "Let's see what is happening today!",
                                      style: kNormalTextStyle),
                                ),
                                CustomCircleAvatar(
                                  image: 'assets/images/Profile.jpg',
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
                      onFormatChanged: (format) {

                        Navigator.pushNamed(context, '/CalendarScreen');
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
                        List<UI_Event> allEvents = [];
                        for (int i = 0; i < globalUIEvents.length; i++) {
                          if (globalUIEvents[i].from.day == day.day &&
                              globalUIEvents[i].from.month == day.month &&
                              globalUIEvents[i].from.year == day.year) {
                            allEvents.add(globalUIEvents[i]);
                          }
                        }
                        return allEvents;
                      },
                    ),
                  )
                ],
              ),
              Text(
                "Event List",
                style: kSubHeadingTextStyle,
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
    ));
  }

  getAtSignAndInitContacts() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });

    initializeContactsService(clientSdkService.atClientInstance, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }
}
