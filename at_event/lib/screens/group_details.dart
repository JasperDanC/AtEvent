import 'package:at_event/screens/list_page.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kColorStyle2),
      home: ListPage(group: widget.group),
    );
  }
}
