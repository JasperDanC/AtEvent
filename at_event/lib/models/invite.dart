import 'package:at_event/models/group_model.dart';
import 'package:flutter/cupertino.dart';

import 'ui_event.dart';



class EventInvite {
  EventInvite({@required this.event, @required this.from});
  final UI_Event event;
  final String from;

}

class GroupInvite {
  GroupInvite({@required this.group, @required this.from});
  final GroupModel group;
  final String from;

}