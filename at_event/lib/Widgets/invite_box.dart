import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

/// UI Widget designed to display all of the atsigns invited to our event/group
/// has a function [onAdd] designed to create functionality to integrate multiple invitation boxes.

class InviteBox extends StatefulWidget {
  InviteBox(
      {@required this.invitees,
        this.onAdd,
      @required this.width,
      @required this.height,
      @required this.addToList});
  final double width;
  final double height;
  final List<String> invitees;
  Function onAdd;
  final bool addToList;
  final TextEditingController controller =  TextEditingController();

  @override
  _InviteBoxState createState() => _InviteBoxState();
}

class _InviteBoxState extends State<InviteBox> {

  final ScrollController _scrollController = ScrollController();
  String _inviteeAtSign;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MaterialButton(
                padding: EdgeInsets.zero,
                minWidth: 0,
                onPressed: () {
                  if (_inviteeAtSign != null) {
                    List<String> withoutAtSigns = [];
                    for (String sign in widget.invitees) {
                      withoutAtSigns.add(sign.replaceAll("@", ""));
                    }
                    setState(() {
                      if (!withoutAtSigns
                          .contains(_inviteeAtSign.replaceAll("@", ""))) {
                        if (widget.addToList) {
                          widget.invitees.add(_inviteeAtSign);
                        }
                        widget.onAdd();
                        widget.controller.clear();

                      }
                    });
                  }
                },
                shape: CircleBorder(),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 33,
                ),
              ),
              Text(
                '@',
                style: TextStyle(color: Color(0xFFaae5e6), fontSize: 22),
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    _inviteeAtSign = value;
                  },
                  controller: widget.controller,
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: kForegroundGrey,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                      controller: _scrollController,
                      itemCount: widget.invitees.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.invitees[index].startsWith("@")
                                ? widget.invitees[index]
                                : "@" + widget.invitees[index],
                            style: kEventDetailsTextStyle,
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
