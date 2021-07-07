import 'package:at_contacts_flutter/screens/contacts_screen.dart';
import 'package:at_event/Widgets/event_tiles.dart';
import 'package:at_event/Widgets/list_page.dart';
import 'package:at_event/data/data_homescreen.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/screens/calendar_screen.dart';
import 'package:at_event/screens/event_create_screen.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

class GroupDetails extends StatefulWidget {
  GroupModel group;
  GroupDetails({this.group});
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kColorStyle2),
      home: ListPage(group: widget.group),
    );
  }
}
