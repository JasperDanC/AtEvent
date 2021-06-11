import 'package:at_event/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'background.dart';
import 'package:at_event/models/event.dart';

void main() => runApp(InviteDetailsScreen(
  invite:  Invite(
    from: '@bobert',
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
  ),
));

class InviteDetailsScreen extends StatelessWidget {
  InviteDetailsScreen({@required this.invite});
  final Invite invite;

  @override
  Widget build(BuildContext context) {
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
                          'Invitation from ' + invite.from,
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
                    invite.event.eventName,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "From: " +
                                DateFormat('MMMM').format(invite.event.from) +
                                " " +
                                invite.event.from.day.toString() +
                                " " +
                                invite.event.from.hour.toString() +
                                ":" +
                                DateFormat('mm').format(invite.event.from) +
                                "\n" +
                                "To: " +
                                DateFormat('MMMM').format(invite.event.to) +
                                " " +
                                invite.event.to.day.toString() +
                                " " +
                                invite.event.to.hour.toString() +
                                ":" +
                                DateFormat('mm').format(invite.event.to),
                            textAlign: TextAlign.end,
                            style: kEventDetailsTextStyle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            invite.event.location,
                            textAlign: TextAlign.end,
                            style: kEventDetailsTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        invite.event.description,
                        overflow: TextOverflow.visible,

                        style: kEventDetailsTextStyle,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    invite.event.peopleGoing.length.toString() + " going",
                    style: kEventDetailsTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {},
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
