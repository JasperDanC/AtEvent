import 'dart:html';

import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;

  EventTile({this.imgAssetPath, this.eventType})

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: kCategoryTile,
          borderRadius: BorderRadius.circular(12)
      ),
      color: kCategoryTile,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Image.asset(imgAssetPath, height: 27),
          SizedBox(height: 12),
          Text(eventType, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String imgAssetPath;
  PopularEventTile({this.address,this.date,this.imgAssetPath,this.desc})
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      decoration: ,
    );
  }
}


}
