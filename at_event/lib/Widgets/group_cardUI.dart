import 'package:at_event/Widgets/circle_avatar.dart';
import 'package:at_event/screens/group_details.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
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
    return Container(
      margin: EdgeInsets.all(8),
      height: 85,
      width: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => GroupDetails(),
                  ),
                );
              },
              child: CustomCircleAvatar(image: 'assets/images/group_icon.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
