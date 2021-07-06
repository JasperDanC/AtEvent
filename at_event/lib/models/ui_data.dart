import 'package:flutter/cupertino.dart';
import 'ui_event.dart';
import 'invite.dart';

class UIData extends ChangeNotifier {
  List<UI_Event> _uiEvents=[];
  List<Invite> _invites =[];


  void addEvent(UI_Event event){
    _uiEvents.add(event);
    notifyListeners();
  }

  void addInvite(Invite invite){
    _invites.add(invite);
    notifyListeners();
  }

  void clear(){
    _uiEvents.clear();
    _invites.clear();
    notifyListeners();
  }

  void clearDuplicateInvites(){

  }
  UI_Event getEvent(int index) => _uiEvents[index];
  Invite getInvite(int index) => _invites[index];

  List<UI_Event> get events => _uiEvents;
  List<Invite> get invites => _invites;
  int get eventsLength => _uiEvents.length;
  int get invitesLength => _invites.length;


}