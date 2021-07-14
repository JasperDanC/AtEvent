import 'dart:io';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:at_event/screens/invitations_screen.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:at_onboarding_flutter/services/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/Widgets/event_tiles.dart';
import '../service/vento_services.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';
import 'package:at_event/data/data_homescreen.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import 'package:at_event/Widgets/circle_avatar.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/Widgets/group_cardUI.dart';
import 'package:at_event/screens/group_create.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color scaffoldColor;
  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  VentoService clientSdkService = VentoService.getInstance();
  String activeAtSign = '';
  GlobalKey<ScaffoldState> scaffoldKey;
  File _image;
  final _picker = ImagePicker();
  bool _nonAsset = false;

  List<EventTypeModel> eventsType = getEventTypes();
  List<UI_Event> events = [];
  List<Widget> groupCards = [];
  List<GroupModel> groups = [
    GroupModel()
      ..title = 'Group Title'
      ..description = 'This is a hard coded test for our group model',
    GroupModel()
      ..title = 'CMPT 222'
      ..description =
          'Welcome to Computer Science 222 where we learn about computers and stuff.',
    GroupModel()
      ..title = 'Study Buddies'
      ..description = 'For those who do not want to repeat any classes'
  ];

  @override
  void initState() {
    getAtSignAndInitContacts();
    VentoService.getInstance().scan(context);
    scaffoldKey = GlobalKey<ScaffoldState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VentoService.getInstance().updateContext(context);
    events.clear();
    for (UI_Event e in Provider.of<UIData>(context).events) {
      if (isToday(e)) {
        events.add(e);
      }
    }
    groupCards.clear();
    groupCards.insert(
      0,
      Container(
        margin: EdgeInsets.all(8),
        height: 85,
        width: 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => GroupCreateScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    for (GroupModel g in Provider.of<UIData>(context).groups) {
      groupCards.add(
        GroupCard(
          group: g,
        ),
      );
    }

    setState(() {});
    SizeConfig().init(context);
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InvitationsScreen()));
              },
            ),
            ListTile(
              title: Text("Contacts"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ));
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
            ListTile(
              title: Text("Delete All Info on Secondary"),
              onTap: () {
                VentoService.getInstance().deleteAll(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                      "Let's see what is happening today!",
                                      style: kNormalTextStyle.copyWith(
                                          fontSize: 16)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                    _nonAsset = true;
                                  },
                                  child: CustomCircleAvatar(
                                    nonAsset: _nonAsset,
                                    image: _image == null
                                        ? 'assets/images/Profile.jpg'
                                        : null,
                                    fileImage: _image != null ? _image : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalendarScreen()));
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

                      for (int i = 0;
                          i < Provider.of<UIData>(context).eventsLength;
                          i++) {
                        if (Provider.of<UIData>(context).getEvent(i).from !=
                            null) {
                          if (Provider.of<UIData>(context)
                                      .getEvent(i)
                                      .from
                                      .day ==
                                  day.day &&
                              Provider.of<UIData>(context)
                                      .getEvent(i)
                                      .from
                                      .month ==
                                  day.month &&
                              Provider.of<UIData>(context)
                                      .getEvent(i)
                                      .from
                                      .year ==
                                  day.year) {
                            allEvents
                                .add(Provider.of<UIData>(context).getEvent(i));
                          }
                        }
                      }
                      return allEvents;
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Today's Events",
              style: kSubHeadingTextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: SizeConfig().screenHeight * 0.36,
              child: events.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 8),
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return PopularEventTile(
                          desc: events[index].eventName,
                          address: events[index].location,
                          date:
                              DateFormat('hh:mm a').format(events[index].from),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EventDetailsScreen(
                                event: events[index],
                              ),
                            ),
                          ),
                        );
                      })
                  : Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            'Seems that you have no events today',
                            style: kSubHeadingTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.4, 0.9],
                        colors: [kGroupBoxGrad1, kGroupBoxGrad2]),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2))
                    ],
                    backgroundBlendMode: BlendMode.modulate),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: groupCards,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  getAtSignAndInitContacts() async {
    String currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });

    initializeContactsService(clientSdkService.atClientInstance, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  bool isToday(UI_Event ui_event) {
    if (!ui_event.isRecurring) {
      return calculateDifference(ui_event.from) == 0;
    } else {
      if (ui_event.realEvent.event.repeatCycle == RepeatCycle.WEEK) {
        int currentWeekday;
        switch (ui_event.realEvent.event.occursOn) {
          case Week.SUNDAY:
            currentWeekday = 7;
            break;
          case Week.MONDAY:
            currentWeekday = 1;
            break;
          case Week.TUESDAY:
            currentWeekday = 2;
            break;
          case Week.WEDNESDAY:
            currentWeekday = 3;
            break;
          case Week.THURSDAY:
            currentWeekday = 4;
            break;
          case Week.FRIDAY:
            currentWeekday = 5;
            break;
          case Week.SATURDAY:
            currentWeekday = 6;
            break;
        }
        return DateTime.now().isAfter(ui_event.from) &&
            DateTime.now().weekday == currentWeekday &&
            ((ui_event.realEvent.event.endsOn == EndsOn.NEVER) ||
                (ui_event.realEvent.event.endsOn == EndsOn.AFTER &&
                    (DateTime.now().difference(ui_event.from).inDays / 7) *
                            ui_event.realEvent.event.repeatDuration <
                        ui_event.realEvent.event.endEventAfterOccurrence) ||
                (ui_event.realEvent.event.endsOn == EndsOn.ON &&
                    DateTime.now()
                        .isBefore(ui_event.realEvent.event.endEventOnDate)));
      } else {
        return DateTime.now().day == ui_event.to.day &&
            ((ui_event.realEvent.event.endsOn == EndsOn.NEVER) ||
                (ui_event.realEvent.event.endsOn == EndsOn.AFTER &&
                    DateTime.now().difference(ui_event.from).inDays /
                            30.436875 <
                        ui_event.realEvent.event.endEventAfterOccurrence) ||
                (ui_event.realEvent.event.endsOn == EndsOn.ON &&
                    DateTime.now()
                        .isBefore(ui_event.realEvent.event.endEventOnDate)));
      }
    }
  }

  _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
