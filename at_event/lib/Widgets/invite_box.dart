import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

/// UI Widget designed to display all of the atsigns invited to our event/group
/// has a function [onAdd] designed to create functionality to integrate multiple invitation boxes.

class InviteBox extends StatefulWidget {
  InviteBox(
      {@required this.invitees,
      @required this.onAdd,
      @required this.width,
      @required this.height});
  final double width;
  final double height;
  final List<String> invitees;
  final Function onAdd;

  @override
  _InviteBoxState createState() => _InviteBoxState();
}

class _InviteBoxState extends State<InviteBox> {
  TextEditingController _controller = TextEditingController();
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
                        widget.invitees.add(_inviteeAtSign);
                      }
                      _controller.clear();
                      widget.onAdd();
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
                  controller: _controller,
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
