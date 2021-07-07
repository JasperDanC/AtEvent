import 'package:at_event/models/ui_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

class EventTile extends StatefulWidget {
  final String imgAssetPath;
  final String eventType;

  EventTile({this.imgAssetPath, this.eventType});

  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: kCategoryTile, borderRadius: BorderRadius.circular(12)),
      color: kCategoryTile,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(widget.imgAssetPath, height: 27),
          SizedBox(height: 12),
          Text(widget.eventType, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}

class PopularEventTile extends StatefulWidget {
  final String desc;
  final String date;
  final String address;
  final String imgAssetPath;
  final Function onPressed;
  final UI_Event event;
  PopularEventTile({
    @required this.address,
    @required this.date,
    @required this.imgAssetPath,
    @required this.desc,
    this.onPressed,
    this.event,
  });

  @override
  _PopularEventTileState createState() => _PopularEventTileState();
}

class _PopularEventTileState extends State<PopularEventTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: kColorStyle3, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today_rounded),
                        SizedBox(width: 8),
                        Text(
                          widget.date,
                          style: kEventDetailsTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on_sharp),
                        SizedBox(width: 8),
                        Text(
                          widget.address,
                          style: kEventDetailsTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            //   child: Image.asset(
            //     widget.imgAssetPath,
            //     height: 100,
            //     width: 120,
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
