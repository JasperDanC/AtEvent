import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_event/models/event_datatypes.dart';
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

    //looks up the key to get the value
    String value = await lookup(atKey);
    print("Key:" + atKey.toString());
    print("Key Value:" + value.toString());

    //if the received atKey is a confirmation of going to an event
    if (atKey.key.startsWith('confirm_') &&
        atKey.sharedBy.replaceFirst("@", "") !=
            atKey.sharedWith.replaceFirst("@", "")) {
      print("got event confirmation " + atKey.key);
      //get the key of the real event
      String keyOfEvent = atKey.key.replaceFirst("confirm_", "");

      //create a replacement atKey to update the peopleGoing
      AtKey updatedKey = AtKey();
      updatedKey.key = keyOfEvent;
      updatedKey.namespace = namespace;

      Metadata metadata = Metadata();
      metadata.ccd = true;
      updatedKey.metadata = metadata;
      updatedKey.sharedWith = atKey.sharedWith;
      updatedKey.sharedBy = atKey.sharedWith;
      //get the original event
      String eventValue = await lookup(updatedKey);
      print(eventValue);
      Map<String, dynamic> jsonValue = json.decode(eventValue);
      EventNotificationModel eventModel =
          EventNotificationModel.fromJson(jsonValue);

      //add the person who confirmed to the event
      eventModel.peopleGoing.add(atKey.sharedBy);

      //convert to back to string
      eventValue =
          EventNotificationModel.convertEventNotificationToJson(eventModel);

      //update on the secondary
      await client.put(updatedKey, eventValue);

      //notify all invitees of the change
      for (String invitee in eventModel.invitees) {
        updatedKey.sharedWith = invitee;
        var operation = OperationEnum.update;
        await client.notify(updatedKey, eventValue, operation);
      }

      //delete the confirmation key
      await client.delete(atKey);
    } else if (!atKey.key.startsWith('confirm_')) {
      // if it is not a confirmation key

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
        print("active: " +
            atKey.sharedWith +
            " from: " +
            eventModel.atSignCreator);
        if (atKey.sharedWith.replaceAll("@", "") !=
                atKey.sharedBy.replaceAll("@", "") &&
            currentUser.replaceAll("@", "") !=
                eventModel.atSignCreator.replaceAll("@", "")) {
          Invite newInvite = Invite(
              event: eventModel.toUI_Event(), from: eventModel.atSignCreator);
          Provider.of<UIData>(context, listen: false).addInvite(newInvite);
        }
      }
    }

    //keep track of the amount of my keys for debugging purposes
    keysFound += 1;
  }
  print(" found $keysFound keys");
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
  print('Monitor started');
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
  if (fromAtSign != to) {
    //lookup that key to add to use the value when needed
    String value = await lookup(realKey);
    print("Value: " + value.toString());
    print('_notificationCallback operation $operation');

    //if it is a delete notification delete the event
    if (operation == 'delete') {
      List<String> names = [];
      for (UI_Event e
          in Provider.of<UIData>(globalContext, listen: false).events) {
        if (e.realEvent.atSignCreator == realKey.sharedWith) {
          names.add(e.eventName);
        }
      }
      if (names.contains(realKey.key.replaceAll("event", ""))) {
        print('deleting event');
        String temp = realKey.sharedBy;
        realKey.sharedBy = realKey.sharedWith;
        realKey.sharedWith = temp;
        await ClientSdkService.getInstance().delete(realKey);
      }
      return;
    }

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

      //delete the confirmation key
      await ClientSdkService.getInstance().delete(realKey);
      scan(globalContext);
      return;
    }

    await ClientSdkService.getInstance().put(realKey, value);
    scan(globalContext);
  }
}
