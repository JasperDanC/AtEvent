import 'package:at_event/screens/background.dart';
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
        description: 'Lunch at my place!\n\n' +
            'Bring some board games, pops, and some delicious sides\n\n' +
            'We will be eating burgers',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
          '@Harriet',
          '@funkyfrog',
          '@3frogs',
          '@dagoth_ur',
          '@clavicus_vile',
          '@BenjaminButton',
          '@samus',
          '@atom_eve',
          '@buggs',
          '@george',
        ]),
  ));
}

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({this.event});
  final Event event;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration:
              BoxDecoration(color: kEventBlue, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.event.description,
                      overflow: TextOverflow.visible,
                      style: kEventDetailsTextStyle,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  widget.event.peopleGoing.length.toString() + " going:",
                  style: kEventDetailsTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      onPressed: () {},
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    Text(
                      '@',
                      style: TextStyle(
                        color: Color(0xFFaae5e6),
                        fontSize: 22
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        style: kEventDetailsTextStyle,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:  BorderSide(color: Colors.white)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:  BorderSide(color: Colors.white)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 20.0
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kForegroundGrey,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 12.0
                          ),
                          controller: _scrollController,
                          itemCount: widget.event.peopleGoing.length,
                          itemBuilder: (context, index){
                            return  Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  widget.event.peopleGoing[index],
                                      style: kEventDetailsTextStyle,
                              ),
                            );
                          }),
                      ),
                      ),
                    ),
                  ),
                FloatingActionButton(
                    onPressed:(){

                    },
                  backgroundColor: kPrimaryBlue,
                  child: Icon(
                    Icons.edit,
                    size: 38,
                    color: Colors.white,
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
