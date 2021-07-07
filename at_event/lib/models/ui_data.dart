import 'package:flutter/cupertino.dart';
import 'ui_event.dart';
import 'invite.dart';
import 'group_model.dart';

class UIData extends ChangeNotifier {
  List<UI_Event> _uiEvents=[];
  List<EventInvite> _eventInvites =[];
  List<GroupInvite> _groupInvites =[];
  List<GroupModel> _groups = [];


  void addEvent(UI_Event event){
    _uiEvents.add(event);
    notifyListeners();
  }
  void addGroup(GroupModel group){
    _groups.add(group);
    notifyListeners();
  }

  void acceptGroupInvite(GroupInvite invite){
    deleteGroupInvite(invite);
    _groups.add(invite.group);
    notifyListeners();
  }

  void deleteGroupInvite(GroupInvite invite){
    _groupInvites.remove(invite);
    notifyListeners();
  }

  void acceptEventInvite(EventInvite invite){
    deleteEventInvite(invite);
    _uiEvents.add(invite.event);
    notifyListeners();
  }

  void deleteEventInvite(EventInvite invite){
    _eventInvites.remove(invite);
    notifyListeners();
  }

  void addEventInvite(EventInvite invite){
    _eventInvites.add(invite);
    notifyListeners();
  }

  void addGroupInvite(GroupInvite invite){
    _groupInvites.add(invite);
    notifyListeners();
  }
  void clear(){
    _uiEvents.clear();
    _eventInvites.clear();
    _groupInvites.clear();
    _groups.clear();
    notifyListeners();
  }

  UI_Event getEvent(int index) => _uiEvents[index];
  EventInvite getEventInvite(int index) => _eventInvites[index];
  GroupInvite getGroupInvite(int index) => _groupInvites[index];
  GroupModel getGroup(int index) => _groups[index];

  List<UI_Event> get events => _uiEvents;
  List<EventInvite> get eventInvites => _eventInvites;
  List<GroupInvite> get groupInvites => _groupInvites;
  List<GroupModel> get groups => _groups;
  int get eventsLength => _uiEvents.length;
  int get eventInvitesLength => _eventInvites.length;
  int get groupInvitesLength => _groupInvites.length;
  int get groupsLength => _groups.length;
}