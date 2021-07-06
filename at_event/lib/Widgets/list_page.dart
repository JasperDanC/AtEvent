import 'package:at_event/data/data_homescreen.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/screens/home_screen.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:intl/intl.dart';

import 'event_tiles.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<EventTypeModel> eventsType = getEventTypes();
  List<UI_Event> events = [];

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: kColorStyle1,
    title: Text(
      'Group Events',
    ),
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.info_sharp),
        onPressed: () {},
      ),
    ],
  );

  final buildBottomAppbar = Container(
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.contacts,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kColorStyle1,
      appBar: topAppBar,
      bottomNavigationBar: buildBottomAppbar,
      body: Container(
        height: SizeConfig().screenHeight * 0.8,
        child: events.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(top: 8),
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return PopularEventTile(
                    desc: events[index].eventName,
                    address: events[index].location,
                    date: DateFormat('hh:MM a').format(events[index].from),
                  );
                })
            : Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 400,
                    child: Text(
                      'Seems that you have no events today',
                      style: kSubHeadingTextStyle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
