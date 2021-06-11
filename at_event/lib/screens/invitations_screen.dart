import 'package:at_event/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_event/models/invite.dart';
import 'package:at_event/models/event.dart';
import 'invitation_details_screen.dart';
import 'package:intl/intl.dart';
import 'background.dart';

List<Invite> invites = [
  Invite(
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
  Invite(
    from: '@frankyG',
    event: Event(
        eventName: "Party Time",
        from: DateTime(2021, 06, 09, 18),
        to: DateTime(2021, 06, 09, 22),
        location: 'FrankyG House, Saskatoon',
        description: 'we getting wild',
        peopleGoing: []),
  ),
  Invite(
    from: '@your_boss',
    event: Event(
        eventName: "Important Business Meeting",
        from: DateTime(2021, 06, 09, 14, 30),
        to: DateTime(2021, 06, 09, 18, 45),
        location: '56 Business Street',
        description: 'business',
        peopleGoing: [
          '@gerald',
          '@norton',
          '@thomas',
          '@MrSmith',
        ]),
  ),
  Invite(
    from: '@gerald',
    event: Event(
        eventName: "Gerald + Gertrude Wedding",
        from: DateTime(2021, 06, 09, 12),
        to: DateTime(2021, 06, 09, 24),
        location: ' 99 RoadName Boulevard, Prince Albert, Saskatchewan',
        description: 'I am getting married\n\n' +
            'pls come\n' +
            'casual dress is prefered',
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
          '@sam',
          '@5678',
          '@jaz',
          '@bagelconservation',
          '@samantha',
          '@geralds_mom',
          '@samuel',
          '@sammy',
          '@gertrude',
          '@frank',
          '@otherpeople',
          '@someone',
          '@buggs2',
          '@george2'
        ]),
  ),
  Invite(
    from: '@bobert',
    event: Event(
        eventName: "Lunch with Thomas",
        from: DateTime(2021, 06, 09, 11),
        to: DateTime(2021, 06, 09, 13),
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
];

void main() => runApp(InvitationsScreen());

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: kBasicBorderRadius, color: kPrimaryBlue),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 46,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        'You have ' +
                            invites.length.toString() +
                            ' invitations',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: invites.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return InviteDetailsScreen(invite: invites[index]);
                                    }));
                                  },
                                  padding: EdgeInsets.zero,
                                  minWidth: 0,
                                  child: Container(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          invites[index].event.eventName,
                                          style: kEventDetailsTextStyle.copyWith(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateFormat('yyyy MMMM dd  hh:mm')
                                                  .format(
                                                      invites[index].event.from)
                                                  .toString() +
                                              " - " +
                                              DateFormat('hh:mm')
                                                  .format(invites[index].event.to)
                                                  .toString(),
                                          style: kEventDetailsTextStyle,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'From ' +
                                              invites[index].from +
                                              '\n' +
                                              'At ' +
                                              invites[index].event.location,
                                          style: kEventDetailsTextStyle.copyWith(
                                            color: kEventBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
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
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
