import 'package:at_event/Widgets/circle_avatar.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_event/screens/group_details.dart';

/// The GroupCard widget contains an image for every group created.

class GroupCard extends StatefulWidget {
  final GroupModel group;
  GroupCard({required this.group});
  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      height: 85,
      width: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => GroupDetails(
                          group: widget.group,
                        ),
                      ),
                    );
                  },
                  child: CustomCircleAvatar(image: 'assets/images/group_icon.jpg', url: widget.group.imageURL),
                ),
              ),
              Container(
                width: 85,
                height: 12,
                child: Text(
                  widget.group.title!,
                  style: kNormalTextStyle.copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
