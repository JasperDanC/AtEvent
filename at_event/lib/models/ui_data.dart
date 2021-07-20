import 'dart:io';

import 'package:at_event/models/event_datatypes.dart';
import 'package:flutter/cupertino.dart';
import 'ui_event.dart';
import 'invite.dart';
import 'group_model.dart';

class UIData extends ChangeNotifier {
  List<File?> _images = [];
  List<String> _profilePicturePaths = [];
  List<UI_Event> _uiEvents = [];
  List<EventInvite> _eventInvites = [];
  List<GroupInvite> _groupInvites = [];
  List<GroupInvite> _deletedGroupInvites = [];
  List<EventInvite> _deletedEventInvites = [];
  List<GroupInvite> _acceptedGroupInvites = [];
  List<EventInvite> _acceptedEventInvites = [];
  List<GroupModel> _groups = [];

  void addImage(File? image) {
    _images.add(image);
  }

  bool isImageAdded(File image) {
    return _images.contains(image);
  }

  bool isImageEmpty() {
    return _images.isEmpty;
  }

  void addPath(String path) {
    _profilePicturePaths.add(path);
    print(_profilePicturePaths);
    notifyListeners();
  }

  bool isPathAdded(String path) {
    return _profilePicturePaths.contains(path);
  }

  bool isPathEmpty() {
    return _profilePicturePaths.isEmpty;
  }

  void addEvent(UI_Event event){
    if(!isAddedEvent(event)){
      _uiEvents.add(event);
    }
    notifyListeners();
  }
  void addGroup(GroupModel group){
    if(!isAddedGroup(group)){
      _groups.add(group);
    }

    notifyListeners();
  }

  GroupModel? getGroupByTitle(String title){
    for(GroupModel g in _groups){
      if(g.title == title){
        return g;
      }
    }
    return null;
  }

  EventNotificationModel? getEventByKey(String key){
    for(UI_Event e in _uiEvents){
      if(e.realEvent.key.toLowerCase().replaceAll(" ", "") == key.toLowerCase().replaceAll(" ", "")){
        return e.realEvent;
      }
    }
    return null;
  }

  UI_Event? getUIEventByName(String? name){
    for(UI_Event e in _uiEvents){
      if(e.eventName == name){
        return e;
      }
    }
    return null;
  }

  void clearAcceptedEvents(){
    _acceptedEventInvites.clear();
    notifyListeners();
  }

  void clearAcceptedGroups(){
    _acceptedGroupInvites.clear();
    notifyListeners();
  }

  void acceptGroupInvite(GroupInvite invite){
    deleteGroupInvite(invite);
    _groups.add(invite.group);
    _acceptedGroupInvites.add(invite);
    notifyListeners();
  }

  bool hasGroup(GroupModel groupModel){
    for(GroupModel g in _groups){
      if(g.title == groupModel.title && g.atSignCreator == groupModel.atSignCreator){
        return true;
      }
    }
    return false;
  }

  bool hasGroupKey(String? keyName){
    for(GroupModel g in _groups){
      if(g.key== keyName){
        return true;
      }
    }
    return false;
  }

  void deleteGroupInvite(GroupInvite invite){
    print(_groupInvites.length);
    _groupInvites.remove(invite);
    print(_groupInvites.length);
    _deletedGroupInvites.add(invite);
    notifyListeners();
  }

  void acceptEventInvite(EventInvite invite){
    deleteEventInvite(invite);
    _uiEvents.add(invite.event);
    _acceptedEventInvites.add(invite);
    notifyListeners();
  }

  void deleteEventInvite(EventInvite invite){
    _eventInvites.remove(invite);
    _deletedEventInvites.add(invite);
    notifyListeners();
  }

  bool isDeletedEventInvite(EventInvite invite) {
    for (EventInvite deleted in _deletedEventInvites) {
      if (deleted.event.eventName == invite.event.eventName &&
          deleted.from == invite.from) {
        return true;
      }
    }
    for (EventInvite accepted in _acceptedEventInvites) {
      if (accepted.event.eventName == invite.event.eventName &&
          accepted.from == invite.from) {
        return true;
      }
    }
    return false;
  }

  bool isAddedEvent(UI_Event e) {
    for (UI_Event storedEvent in _uiEvents) {
      if (e.eventName == storedEvent.eventName &&
          e.realEvent.atSignCreator == storedEvent.realEvent.atSignCreator &&
          e.description == storedEvent.description) {
        return true;
      }
    }
    return false;
  }

  bool isDeletedGroupInvite(GroupInvite invite) {
    for (GroupInvite deleted in _deletedGroupInvites) {
      if (deleted.group.title == invite.group.title &&
          deleted.from == invite.from) {
        return true;
      }
    }
    for (GroupInvite accepted in _acceptedGroupInvites) {
      if (accepted.group.title == invite.group.title &&
          accepted.from == invite.from) {
        return true;
      }
    }
    return false;
  }

  bool isAddedGroup(GroupModel g) {
    for (GroupModel storedGroup in _groups) {
      if (g.title == storedGroup.title &&
          g.atSignCreator == storedGroup.atSignCreator &&
          g.description == storedGroup.description) {
        return true;
      }
    }
    return false;
  }

  void addEventInvite(EventInvite invite) {
    _eventInvites.add(invite);
    notifyListeners();
  }

  void addGroupInvite(GroupInvite invite) {
    _groupInvites.add(invite);
    notifyListeners();
  }

  void clear() {
    _uiEvents.clear();
    _eventInvites.clear();
    _groupInvites.clear();
    _groups.clear();
    _images.clear();
    notifyListeners();
  }

  UI_Event getEvent(int index) => _uiEvents[index];
  EventInvite getEventInvite(int index) => _eventInvites[index];
  GroupInvite getGroupInvite(int index) => _groupInvites[index];
  GroupModel getGroup(int index) => _groups[index];
  String getPath(int index) => _profilePicturePaths[index];
  File? getImage(int index) => _images[index];

  List<UI_Event> get events => _uiEvents;
  List<EventInvite> get eventInvites => _eventInvites;
  List<GroupInvite> get groupInvites => _groupInvites;
  List<EventInvite> get acceptedEventInvites => _acceptedEventInvites;
  List<GroupInvite> get acceptedGroupInvites => _acceptedGroupInvites;
  List<EventInvite> get deletedEventInvites => _deletedEventInvites;
  List<GroupInvite> get deletedGroupInvites => _deletedGroupInvites;
  List<GroupModel> get groups => _groups;
  List<String> get profilePicturePaths => _profilePicturePaths;
  List<File?> get images => _images;
  int get eventsLength => _uiEvents.length;
  int get eventInvitesLength => _eventInvites.length;
  int get groupInvitesLength => _groupInvites.length;
  int get groupsLength => _groups.length;
  int get pathsLength => _profilePicturePaths.length;
  int get imagesLength => _images.length;
}
