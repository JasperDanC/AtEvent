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
      decoration: BoxDecoration(
        color: kColorStyle3,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width-100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      desc,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today_rounded),
                        SizedBox(width: 8),
                        Text(date, style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                        ),),
                        
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_sharp
                        ),
                        SizedBox(width: 8),
                        Text(date,style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                        ),),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: <Widget>[],
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}


}
