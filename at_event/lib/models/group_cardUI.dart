import 'package:at_event/Widgets/circle_avatar.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_event/screens/group_details.dart';
import 'dart:math';

class GroupCard extends StatefulWidget {
  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  List colors = [
    kColorStyle1,
    kColorStyle2,
    kColorStyle3,
    kBackgroundGrey,
    kEventBlue,
    kCategoryTile,
    kGreyishWhite
  ];

  Random random = new Random();

  int changeIndexColor() {
    index = random.nextInt(6);
    return index;
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    index = changeIndexColor();
    return MaterialButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        GroupDetails()));
      },
      shape: CircleBorder(),
      padding: EdgeInsets.zero,
      minWidth: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        height: 85,
        width: 85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CustomCircleAvatar(image: 'assets/images/group_icon.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
