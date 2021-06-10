import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:at_event/constants.dart';
import 'package:at_event/models/event.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(EventDetailsScreen(
    event: Event(
        eventName: "Lunch with Thomas",
        from: DateTime(2021, 06, 09, 6),
        to: DateTime(2021, 06, 09, 9),
        location: '123 Street Avenue N.',
        description:
        'Lunch at my place!\n\n'+
        'Bring some board games, pops, and some delicious sides\n\n'+
        'We will be eating burgers',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
          '@Harriet',
          '@funkyfrog',
        ]

    ),
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
                Divider(
                  color: Colors.white,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "From: " +
                          DateFormat('MMMM').format(widget.event.from) +
                          " " +
                          widget.event.from.day.toString() +
                          " " +
                          widget.event.from.hour.toString() +
                          ":" +
                          DateFormat('mm').format(widget.event.from) +
                          "\n" +
                          "To: " +
                          DateFormat('MMMM').format(widget.event.to) +
                          " " +
                          widget.event.to.day.toString() +
                          " " +
                          widget.event.to.hour.toString() +
                          ":" +
                          DateFormat('mm').format(widget.event.to),
                      textAlign: TextAlign.end,
                      style: kEventDetailsTextStyle,
                    ),
                    Text(
                      widget.event.location,
                      textAlign: TextAlign.end,
                      style: kEventDetailsTextStyle,
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  widget.event.description,
                  style: kEventDetailsTextStyle,
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  widget.event.peopleGoing.length.toString() + " going:",
                  style: kEventDetailsTextStyle,
                ),
                MaterialButton(
                    onPressed: (){},
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.add
                    ),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
