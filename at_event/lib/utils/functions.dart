import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/models/ui_event.dart';
import 'package:provider/provider.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/models/invite.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'package:at_event/service/client_sdk_service.dart';

BuildContext globalContext;

/// Scan for [AtKey] objects with the correct regex.
scan(BuildContext context) async {
  print("started scan");
  if (context == null) {
    context = globalContext;
  } else {
    globalContext = context;
  }
  //counter to keep track of the amount of Key Value pairs stored in the secondary server
  int keysFound = 0;

  //gets the client sdk service to fill a list with all the atKeys
  List<AtKey> response;
  ClientSdkService client = ClientSdkService.getInstance();
  response = await client.getAtKeys();
  String currentUser = await ClientSdkService.getInstance().getAtSign();

  //clears UI lists so that they can be refilled with the updated information
  Provider.of<UIData>(context, listen: false).clear();

  for (AtKey atKey in response) {
    //await client.delete(atKey);
    if (atKey.sharedBy != 'null' && atKey.sharedBy != null) {
      //looks up the key to get the value
      String value = await lookup(atKey);
      print("Key:" + atKey.toString());
      print("Key Value:" + value.toString());

      if (!atKey.key.startsWith('confirm_') &&
          !atKey.key.startsWith('group_')) {
        // if it is not a confirmation key or a group

        //decode the json string into a json map
        Map<String, dynamic> jsonValue = json.decode(value);
        //make the event Model from the json
        EventNotificationModel eventModel =
        EventNotificationModel.fromJson(jsonValue);

        //if I am going to this event add it to my calendar otherwise add it to my invitation list
        if (eventModel.peopleGoing.contains(currentUser) &&
            !(eventModel.atSignCreator == currentUser &&
                atKey.sharedWith != currentUser)) {

            Provider.of<UIData>(context, listen: false)
                .addEvent(eventModel.toUI_Event());

        } else {
          if (atKey.sharedWith.replaceAll("@", "") !=
              atKey.sharedBy.replaceAll("@", "") &&
              currentUser.replaceAll("@", "") !=
                  eventModel.atSignCreator.replaceAll("@", "")) {
            print(" Got invite to: " + currentUser);
            EventInvite newInvite = EventInvite(
                event: eventModel.toUI_Event(), from: eventModel.atSignCreator);

            if (!Provider
                .of<UIData>(context, listen: false).isDeletedEventInvite(newInvite)) {
              Provider.of<UIData>(context, listen: false)
                  .addEventInvite(newInvite);
            }
          } else {
            await client.delete(atKey);
          }
        }
      } else if (atKey.key.startsWith('group_')) {
        //decode the json string into a json map
        Map<String, dynamic> jsonValue = json.decode(value);
        //make the event Model from the json
        GroupModel groupModel = GroupModel.fromJson(jsonValue);

        if (groupModel.atSignMembers.contains(currentUser) &&
            !(groupModel.atSignCreator == currentUser &&
                atKey.sharedWith != currentUser)) {

            Provider.of<UIData>(context, listen: false).addGroup(groupModel);

        } else {
          if (atKey.sharedWith.replaceAll("@", "") !=
              atKey.sharedBy.replaceAll("@", "") &&
              currentUser.replaceAll("@", "") !=
                  groupModel.atSignCreator.replaceAll("@", "")) {
            GroupInvite newInvite =
            GroupInvite(group: groupModel, from: groupModel.atSignCreator);

            if (!Provider
                .of<UIData>(context, listen: false)
                .deletedGroupInvites
                .contains(newInvite) &&
                !Provider
                    .of<UIData>(context, listen: false)
                    .acceptedGroupInvites
                    .contains(newInvite)) {
              Provider.of<UIData>(context, listen: false)
                  .addGroupInvite(newInvite);
            }
          } else {
            await client.delete(atKey);
          }
        }
      }
    }
    for (EventInvite ei
    in Provider
        .of<UIData>(context, listen: false)
        .acceptedEventInvites) {
      if (!Provider
          .of<UIData>(context, listen: false).isAddedEvent(ei.event)) {
        Provider.of<UIData>(context, listen: false).addEvent(ei.event);

      }
    }

    for (GroupInvite gi
    in Provider
        .of<UIData>(context, listen: false)
        .acceptedGroupInvites) {
      if (!Provider
          .of<UIData>(context, listen: false)
          .isAddedGroup(gi.group)) {
        Provider.of<UIData>(context, listen: false).addGroup(gi.group);

      }
    }

    //keep track of the amount of my keys for debugging purposes
    keysFound += 1;
  }
  print(" found $keysFound keys");
}

deleteAll(BuildContext context) async {
  print("started deletion");
  globalContext = context;
  //counter to keep track of the amount of Key Value pairs stored in the secondary server
  int keysFound = 0;

  //gets the client sdk service to fill a list with all the atKeys
  List<AtKey> response;
  ClientSdkService client = ClientSdkService.getInstance();
  response = await client.getAtKeys();
  String currentUser = await ClientSdkService.getInstance().getAtSign();

  //clears UI lists so that they can be refilled with the updated information
  Provider.of<UIData>(context, listen: false).clear();

  for (AtKey atKey in response) {
    await client.delete(atKey);
    keysFound++;
  }
  print("Deleted $keysFound keys");
}

/// Look up a value corresponding to an [AtKey] instance.
Future<String> lookup(AtKey atKey) async {
  // If an AtKey object exists
  if (atKey != null) {
    // Simply get the AtKey object utilizing the serverDemoService's get method
    return await ClientSdkService.getInstance().get(atKey);
  }
  return '';
}

Future<bool> startMonitor(currentAtSign) async {
  await ClientSdkService.getInstance()
      .startMonitor(currentAtSign, _notificationCallback);
  return true;
}

void _notificationCallback(dynamic response) async {
  print('fnCallBack called in event service');
  //remove notification specificier
  response = response.replaceFirst('notification:', '');
  //get the json from the response
  var responseJson = jsonDecode(response);

  //get all the important values from the json
  var notificationKey = responseJson['key'];
  var fromAtSign = responseJson['from'];
  //var value = responseJson['value'];
  var to = responseJson['to'];
  var atKey = notificationKey.split(':')[1];
  var operation = responseJson['operation'];

  //create a real AtKey from data collected from the json
  AtKey realKey = AtKey.fromString(atKey);
  var sharedMetadata = Metadata()..ccd = true;

  realKey.sharedBy = fromAtSign;
  realKey.sharedWith = to;
  realKey.metadata = sharedMetadata;

  print("From: " +
      fromAtSign +
      "\nTo: " +
      to +
      "\nGot key: " +
      atKey +
      "\nTranslated to: " +
      realKey.toString());
  if (fromAtSign.replaceAll("@","") != to.replaceAll("@","") && fromAtSign != null && fromAtSign != 'null') {
    //lookup that key to add to use the value when needed
    print('_notificationCallback operation $operation');

    //if it is a delete notification delete the event
    if (operation == 'delete') {
      // create a list of names of the events that sharedWith (which would
      // be the activeAtSign) made.
      List<String> names = [];
      for (UI_Event e
          in Provider.of<UIData>(globalContext, listen: false).events) {
        if (e.realEvent.atSignCreator == realKey.sharedWith) {
          names.add(e.eventName.toLowerCase());
        }
      }

      //if the the key being deleted is for an event made by the activeAtSign
      if (names.contains(realKey.key.replaceFirst("event", ""))) {
        //swap shared with and shared by
        String temp = realKey.sharedBy;
        realKey.sharedBy = realKey.sharedWith.replaceAll("@", "");
        realKey.sharedWith = temp;
        print('deleting event: ' + realKey.toString());
        //delete the shared version of the key.
        // when a key is shared a separate shared version is made so we
        // gotta delete the shared version so it disappears on this secondary as
        // well as there person it was shared with
        await ClientSdkService.getInstance().delete(realKey);
        return;
      } else {
        //if I did not create this key and got the delete notification then all
        // i do is  delete the key
        await ClientSdkService.getInstance().delete(realKey);
      }
      scan(globalContext);
      // don't run any other notification code as the delete notification has
      // been dealt with
      return;
    }

    // getting a notification that someone has accepted an invite
    if (realKey.toString().contains("confirm_")) {
      print("got event confirmation " + realKey.key);
      //get the key of the real event
      String keyOfEvent = realKey.key.replaceFirst("confirm_", "");

      //create a replacement atKey to update the peopleGoing
      AtKey updatedKey = AtKey();
      updatedKey.key = keyOfEvent;
      updatedKey.namespace = namespace;

      Metadata metadata = Metadata();
      metadata.ccd = true;
      updatedKey.metadata = metadata;
      updatedKey.sharedWith = realKey.sharedWith;
      updatedKey.sharedBy = realKey.sharedWith;
      //get the original event
      String eventValue = await lookup(updatedKey);
      print(eventValue);
      Map<String, dynamic> jsonValue = json.decode(eventValue);
      EventNotificationModel eventModel =
          EventNotificationModel.fromJson(jsonValue);

      //add the person who confirmed to the event
      eventModel.peopleGoing.add(realKey.sharedBy);

      //convert to back to string
      eventValue =
          EventNotificationModel.convertEventNotificationToJson(eventModel);

      //update on the secondary
      await ClientSdkService.getInstance().put(updatedKey, eventValue);

      //notify all invitees of the change
      for (String invitee in eventModel.invitees) {
        updatedKey.sharedWith = invitee;
        await ClientSdkService.getInstance().put(updatedKey, eventValue);
      }

      //don't do more code we have dealt with the notification
      return;
    }
    // if we get here it is not a delete or a confirmation
    // just throw that key on the secondary it is a invitation or event to be
    // added to the UI properly in the scan
    if (operation == 'update') {
      String value = await lookup(realKey);
      print("Value: " + value.toString());
      if(realKey.key.startsWith("group_")){
        GroupModel group = GroupModel.fromJson(jsonDecode(value));
        Provider.of<UIData>(globalContext, listen: false).deleteGroupByIdentical(group);
        Provider.of<UIData>(globalContext, listen: false).acceptedGroupInvites.clear();
      } else {
        UI_Event event = EventNotificationModel.fromJson(jsonDecode(value)).toUI_Event();
        Provider.of<UIData>(globalContext, listen: false).deleteEventByIdentical(event);
        Provider.of<UIData>(globalContext, listen: false).acceptedEventInvites.clear();
      }
      await ClientSdkService.getInstance().put(realKey, value);
      scan(globalContext);
    }
  }
}
