import 'package:at_contacts_flutter/screens/contacts_screen.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:at_event/screens/event_create_screen.dart';
import 'package:at_event/screens/event_details_screen.dart';
import 'package:at_event/screens/group_information_screen.dart';
import 'package:at_event/screens/home_screen.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_event/models/ui_data.dart';

import '../Widgets/event_tiles.dart';

class ListPage extends StatefulWidget {
  final GroupModel group;
  ListPage({required this.group});
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  List<UI_Event> events = [];
  String activeAtSign = '';
  @override
  void initState() {
    getAtSign();
    VentoService.getInstance().scan(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    events.clear();
    for (UI_Event e in Provider.of<UIData>(context, listen: false).events) {
      if (e.realEvent.groupKey != null &&
          e.realEvent.groupKey == widget.group.key) {
        events.add(e);
      }
    }

    return Scaffold(
      backgroundColor: kColorStyle1,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: kColorStyle1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => VentoHomeScreen(),
              ),
            );
          },
        ),
        title: Text(
          widget.group.title! + ' Events',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_sharp),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => GroupInformation(
                    group: widget.group,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: kColorStyle1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => VentoHomeScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => EventCreateScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CalendarScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.contacts,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ContactsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: SizeConfig().screenHeight * 0.8,
        child: events.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(top: 8),
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return TodayEventTile(
                    title: events[index].eventName,
                    address: events[index].location,
                    date:
                        DateFormat('hh:mm a').format(events[index].startTime!),
                    event: events[index],
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => EventDetailsScreen(
                            event: events[index],
                          ),
                        ),
                      );
                    },
                    imgAssetPath:
                        'assets/images/none.png', // If for some reason any image fails to load or something, it will default to the unknown category icon.
                  );
                })
            : Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        VentoService.getInstance().compareAtSigns(activeAtSign, widget.group.atSignCreator) ? 'Seems that you have no events for this group. \n Try and make one!' :
                        'Seems that you have no events for this group. \n Ask the group creator, ${widget.group.atSignCreator}, to make one!',
                        style: kSubHeadingTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }
}
