import 'package:at_event/Widgets/list_page.dart';
import 'package:at_event/screens/background.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';

void main() => runApp(GroupDetails());

class GroupDetails extends StatefulWidget {
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kColorStyle2),
      home: ListPage(),
    );
  }
}
