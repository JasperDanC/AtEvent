import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/models/uicalendar_event_data_source.dart';
import 'package:at_event/service/client_sdk_service.dart';

void main() {
  runApp(CalendarScreen());
}

class CalendarScreen extends StatefulWidget {


  CalendarScreen({this.specificDay}){
    if(specificDay != null){
      switchIndex = 2;
      _controller.displayDate = specificDay;
      _controller.view = CalendarView.day;
    }
  }


  int switchIndex = 0;
  final DateTime specificDay;
  final CalendarController _controller = CalendarController();

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  GlobalKey<ScaffoldState> scaffoldKey;
  ClientSdkService clientSdkService = ClientSdkService.getInstance();

  String activeAtSign = '';
  @override
  void initState() {
    getAtSign();
    scaffoldKey = GlobalKey<ScaffoldState>();

    _scan();
    super.initState();
  }

  EventDataSource _getEventData() {
    return EventDataSource(kDummyEvents);
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/HomeScreen');
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 50.0,
                        ),),
                  ],
                ),
                ToggleSwitch(
                  totalSwitches: 3,
                  labels: ["Month", "Week", "Day"],
                  initialLabelIndex: widget.switchIndex,
                  onToggle: (index) {
                    setState(() {
                      widget.switchIndex = index;
                      switch (index) {
                        case 0:
                          {
                            widget._controller.view = CalendarView.month;
                          }
                          break;
                        case 1:
                          {
                            widget._controller.view = CalendarView.week;
                          }
                          break;
                        case 2:
                          {
                            widget._controller.view = CalendarView.day;
                          }
                          break;
                      }
                    });
                  },
                ),
                Expanded(
                  child: SfCalendar(
                    onTap: (CalendarTapDetails ctd) {
                      if (widget.switchIndex == 0) {
                        setState(() {
                          widget.switchIndex = 2;
                          widget._controller.view = CalendarView.day;
                        });
                      } else {
                        if (ctd.appointments.length != null) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EventDetailsScreen(
                              event: UI_Event(
                                  eventName: "Lunch with Thomas",
                                  from: DateTime(2021, 06, 09, 6),
                                  to: DateTime(2021, 06, 09, 9),
                                  location: '123 Street Avenue N.',
                                  description: 'Lunch at my place!\n\n' +
                                      'Bring some board games, pops, and some delicious sides\n\n' +
                                      'We will be eating burgers',
                                  peopleGoing: [
                                    '@gerald',
                                    '@norton',
                                    '@thomas',
                                    '@MrSmith',
                                    '@Harriet',
                                    '@funkyfrog',
                                    '@3frogs',
                                    '@dagoth_ur',
                                    '@clavicus_vile',
                                    '@BenjaminButton',
                                    '@samus',
                                    '@atom_eve',
                                    '@buggs',
                                    '@george',
                                  ],
                              category: 'Party',
                              ),

                            );
                          }));
                        }
                      }
                    },
                    dataSource: _getEventData(),
                    controller: widget._controller,
                    monthCellBuilder: (context, details) {
                      bool isTopLeft =
                          details.visibleDates.first == details.date;
                      bool isBottomRight =
                          details.visibleDates.last == details.date;
                      bool isTopRight = details.visibleDates[6] == details.date;
                      bool isBottomLeft =
                          details.visibleDates[35] == details.date;

                      BorderRadius dateRadius = BorderRadius.only(
                        topRight:
                            isTopRight ? Radius.circular(20.0) : Radius.zero,
                        topLeft:
                            isTopLeft ? Radius.circular(20.0) : Radius.zero,
                        bottomLeft:
                            isBottomLeft ? Radius.circular(20.0) : Radius.zero,
                        bottomRight:
                            isBottomRight ? Radius.circular(20.0) : Radius.zero,
                      );

                      int dayIndex = details.visibleDates.indexOf(details.date);

                      int lastDayOfLastMonth = 0;
                      while (
                          details.visibleDates[lastDayOfLastMonth].day != 1) {
                        lastDayOfLastMonth++;
                      }
                      lastDayOfLastMonth--;

                      int firstDayOfNextMonth = 26;
                      while (
                          details.visibleDates[firstDayOfNextMonth].day != 1) {
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
                                radius:
                                    details.appointments.length != 0 ? 15 : 0,
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
                    backgroundColor: widget._controller.view == CalendarView.month
                        ? Colors.transparent
                        : Colors.white,
                    cellBorderColor: widget._controller.view == CalendarView.month
                        ? Colors.white
                        : Colors.grey[110],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: FloatingActionButton(
                        backgroundColor: kBackgroundGrey,
                        child: Icon(Icons.add),
                        onPressed: () {
                          Navigator.pushNamed(context, '/EventCreateScreen');
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// Scan for [AtKey] objects with the correct regex.
  _scan() async {
    print("started scan");
    int keysFound = 0;
    List<AtKey> response;


    response = await clientSdkService.getAtKeys();

    // Instantiating a list of strings
    List<String> responseList = [];


    for (AtKey atKey in response) {

      String value = await _lookup(atKey);

      print("Key Value:" + value);

      keysFound += 1;
      responseList.add(value);
    }
    print(" found $keysFound keys");
    return responseList;
  }
  /// Look up a value corresponding to an [AtKey] instance.
  Future<String> _lookup(AtKey atKey) async {
    // If an AtKey object exists
    if (atKey != null) {
      // Simply get the AtKey object utilizing the serverDemoService's get method
      return await clientSdkService.get(atKey);
    }
    return '';
  }
  getAtSign() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
