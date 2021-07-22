import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

/// TodayEvenTile is a widget that stores the event's location, date of occurrence,
/// description and
//ignore: must_be_immutable
class TodayEventTile extends StatefulWidget {
  final String title;
  final String date;
  final String address;
  String imgAssetPath;
  final Function? onPressed;
  final UI_Event event;
  TodayEventTile({
    required this.address,
    required this.date,
    required this.imgAssetPath,
    required this.title,
    this.onPressed,
    required this.event,
  });

  @override
  _TodayEventTileState createState() => _TodayEventTileState();
}

class _TodayEventTileState extends State<TodayEventTile> {
  @override
  Widget build(BuildContext context) {
    setCategoryAsset(widget.event.realEvent);
    return GestureDetector(
      onTap: widget.onPressed as void Function()?,
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
                      widget.title,
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
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image(
                image: AssetImage(widget.imgAssetPath),
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setCategoryAsset(EventNotificationModel event) {
    switch (event.category) {
      case EventCategory.Class:
        widget.imgAssetPath = 'assets/images/clock.png';
        break;
      case EventCategory.Tutorial:
        widget.imgAssetPath = 'assets/images/tutorial.png';
        break;
      case EventCategory.StudySession:
        widget.imgAssetPath = 'assets/images/study.png';
        break;
      case EventCategory.Hangout:
        widget.imgAssetPath = 'assets/images/hangout.png';
        break;
      case EventCategory.Lab:
        widget.imgAssetPath = 'assets/images/lab.png';
        break;
      case EventCategory.StudentClubEvent:
        widget.imgAssetPath = 'assets/images/student_club.png';
        break;
      case EventCategory.None:
        widget.imgAssetPath = 'assets/images/none.png';
        break;
      default:
        widget.imgAssetPath = 'assets/images/none.png';
    }
  }
}
