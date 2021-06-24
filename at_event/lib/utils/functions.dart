import 'dart:convert';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/models/invite.dart';
import 'constants.dart';
import 'package:at_event/service/client_sdk_service.dart';


/// Scan for [AtKey] objects with the correct regex.
scan(String activeAtSign) async {
  print("started scan");
  int keysFound = 0;
  List<AtKey> response;

  ClientSdkService client = ClientSdkService.getInstance();
  response = await client.getAtKeys();

  // Instantiating a list of strings
  List<String> responseList = [];

  globalUIEvents.clear();
  globalInvites.clear();


  for (AtKey atKey in response) {
    //await client.delete(atKey);
    String value = await lookup(atKey);
    print("Key:"+atKey.toString());
    print("Key Value:" + value.toString());

    //if the received atKey is a confirmation of going to an event
    if(atKey.key.startsWith('confirm_') && atKey.sharedBy != atKey.sharedWith){
      print("got event confirmation");
      //get the key of the real event
      String keyOfEvent = atKey.key.replaceFirst("confirm_","");

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
      String eventValue = await client.get(updatedKey);
      Map<String, dynamic> jsonValue = json.decode(eventValue);
      EventNotificationModel eventModel = EventNotificationModel.fromJson(jsonValue);

      //add the person who confirmed to the event
      eventModel.peopleGoing.add(atKey.sharedBy);

      //convert to back to string
      eventValue = EventNotificationModel.convertEventNotificationToJson(
          eventModel);

      //update on the secondary
      await client.put(updatedKey, eventValue);

      //notify all invitees of the change
      for(String invitee in eventModel.invitees){
        updatedKey.sharedWith = invitee;
        var operation = OperationEnum.update;
        await client.notify(updatedKey, eventValue,operation);
      }

      //delete the confirmation key
      await client.delete(atKey);

    } else {
      Map<String, dynamic> jsonValue = json.decode(value);
      EventNotificationModel eventModel = EventNotificationModel.fromJson(jsonValue);
      if(atKey.sharedWith == eventModel.atSignCreator || eventModel.peopleGoing.contains(atKey.sharedWith)){
        globalUIEvents.add(eventModel.toUI_Event());
      } else {
        print("active: "+ atKey.sharedWith + " from: "+ eventModel.atSignCreator );
        Invite newInvite = Invite(event: eventModel.toUI_Event(),from: eventModel.atSignCreator);
        globalInvites.add(newInvite);
      }
    }


    keysFound += 1;
    responseList.add(value);
  }
  print(" found $keysFound keys");
  return responseList;
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