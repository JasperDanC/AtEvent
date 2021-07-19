import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'background.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:at_event/models/event_datatypes.dart';

void main() => runApp(InviteDetailsScreen(
  eventInvite:  EventInvite(
    from: '@bobert',
    event: UI_Event(
        eventName: "Lunch with Thomas",
        startTime: DateTime(2021, 06, 09, 6),
        endTime: DateTime(2021, 06, 09, 9),
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
  ),
));

class InviteDetailsScreen extends StatelessWidget {
  InviteDetailsScreen({this.eventInvite,this.groupInvite,this.isEvent});
  final EventInvite eventInvite;
  final GroupInvite groupInvite;
  final bool isEvent;
  String timeText;

  @override
  Widget build(BuildContext context) {
    if(isEvent){
      if(!eventInvite.event.isRecurring){
        timeText = "From: " +
            DateFormat('MMMM').format(eventInvite.event.startTime) +
            " " +
            eventInvite.event.startTime.day.toString() +
            " " +
            eventInvite.event.startTime.hour.toString() +
            ":" +
            DateFormat('mm').format(eventInvite.event.startTime) +
            "\n" +
            "To: " +
            DateFormat('MMMM').format(eventInvite.event.endTime) +
            " " +
            eventInvite.event.endTime.day.toString() +
            " " +
            eventInvite.event.endTime.hour.toString() +
            ":" +
            DateFormat('mm').format(eventInvite.event.endTime);
      } else {
        if (eventInvite.event.realEvent.event.repeatCycle == RepeatCycle.WEEK) {
          timeText = getWeekString(eventInvite.event.realEvent.event.occursOn) +
              "s\nFrom: " +
              eventInvite.event.startTime.hour.toString() +
              ":" +
              DateFormat('mm').format(eventInvite.event.startTime) +
              "\n" +
              "To: " +
              eventInvite.event.endTime.hour.toString() +
              ":" +
              DateFormat('mm').format(eventInvite.event.endTime);
        } else if (eventInvite.event.realEvent.event.repeatCycle ==
            RepeatCycle.MONTH) {
          timeText = eventInvite.event.startTime.day.toString() +
              " of each Month" +
              "\nFrom: " +
              eventInvite.event.startTime.hour.toString() +
              ":" +
              DateFormat('mm').format(eventInvite.event.startTime) +
              "\n" +
              "To: " +
              eventInvite.event.endTime.hour.toString() +
              ":" +
              DateFormat('mm').format(eventInvite.event.endTime);
        }
      }
    }

    return Background(
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 100,
            horizontal: 30,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: kBasicBorderRadius,
              color: kPrimaryBlue
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Invitation from ' + (isEvent ? eventInvite.from : groupInvite.from),
                          style: kEventDetailsTextStyle,
                        ),
                      ),
                      MaterialButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        padding: EdgeInsets.zero,
                        minWidth: 0,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    isEvent ? eventInvite.event.eventName : groupInvite.group.title,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Column(
                    children: isEvent ? [
                      Divider(
                        color: Colors.white,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:  Text(
                                (isEvent ? timeText : ''),
                                textAlign: TextAlign.end,
                                style: kEventDetailsTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                isEvent ? eventInvite.event.location : '',
                                textAlign: TextAlign.end,
                                style: kEventDetailsTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ] : [],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        isEvent ? eventInvite.event.description : groupInvite.group.description,
                        overflow: TextOverflow.visible,

                        style: kEventDetailsTextStyle,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    isEvent ?
                    eventInvite.event.peopleGoing.length.toString() + " going" :
                    groupInvite.group.atSignMembers.length.toString() + " members",
                    style: kEventDetailsTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {


                        },
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        color: Colors.green,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 77,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        color: Colors.red,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 77,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }


}
