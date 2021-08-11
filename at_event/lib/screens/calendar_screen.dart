import 'package:at_event/models/ui_data.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/screens/event_create_screen.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/uicalendar_event_data_source.dart';
import 'package:at_event/service/vento_services.dart';
import 'home_screen.dart';
import 'package:at_common_flutter/services/size_config.dart';

// ignore: must_be_immutable
class CalendarScreen extends StatefulWidget {
  final DateTime? specificDay;
  CalendarScreen({this.specificDay}) {
    //if the calendar was set to open to a specific day
    if (specificDay != null) {
      //set the view to that date
      switchIndex = 2;
      _controller.displayDate = specificDay;
      _controller.view = CalendarView.day;
    }
  }

  //set default calendar view to month view
  int switchIndex = 0;

  //controller for calendar
  final CalendarController _controller = CalendarController();

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String activeAtSign = '';
  @override
  void initState() {
    //sets activeAtSign to the currently logged in one
    getAtSign();
    //scans so that the correct information will be displayed
    VentoService.getInstance().scan(context);
    super.initState();
  }

  //weird and necessary function for syncfusion calendar to work
  EventDataSource _getEventData() {
    return EventDataSource(Provider.of<UIData>(context).events);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kPrimaryBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 55,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your Calendar",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VentoHomeScreen()));
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
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
                        if (ctd.appointments != null ||
                            ctd.appointments!.length != 0) {
                          UI_Event? foundEvent;
                          if (ctd.appointments![0] is Appointment) {
                            foundEvent = Provider.of<UIData>(context,
                                    listen: false)
                                .getUIEventByName(ctd.appointments![0].subject);
                          } else {
                            foundEvent =
                                Provider.of<UIData>(context, listen: false)
                                    .getUIEventByName(
                                        ctd.appointments![0].eventName);
                          }

                          if (foundEvent != null) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EventDetailsScreen(event: foundEvent);
                            }));
                          } else {
                            print('did not find event');
                          }
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

                      int numAppointments = 0;
                      List<Object> seen = [];

                      for (Object app in details.appointments) {
                        if (!seen.contains(app)) {
                          seen.add(app);
                          numAppointments += 1;
                        }
                      }

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
                                radius: numAppointments != 0 ? 15.toHeight : 0,
                                child: Text(
                                  numAppointments != 0
                                      ? numAppointments.toString()
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
                    backgroundColor:
                        widget._controller.view == CalendarView.month
                            ? Colors.transparent
                            : Colors.white,
                    cellBorderColor:
                        widget._controller.view == CalendarView.month
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EventCreateScreen()));
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

  //straightforward getting the logged in at sign function
  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
