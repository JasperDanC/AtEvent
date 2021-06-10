import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/models/event.dart';

void main() {
  runApp(EventDetailsScreen(
    event: Event(
        eventName: "Test Event 1",
        from: DateTime(2021, 06, 09, 6),
        to: DateTime(2021, 06, 09, 9)),
  ));
}

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({this.event});
  final Event event;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(45.0),
            bottomLeft: Radius.circular(45.0),
          )),
          centerTitle: true,
          backgroundColor: kPrimaryBlue,
          title: Text(
            "@Vento",
            style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        backgroundColor: kBackgroundGrey,
        body: Container(
          decoration: BoxDecoration(
              color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.event.eventName,
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
