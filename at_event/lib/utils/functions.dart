import 'dart:convert';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_commons/at_commons.dart';
import 'constants.dart';
import 'package:at_event/service/client_sdk_service.dart';


/// Scan for [AtKey] objects with the correct regex.
scan() async {
  print("started scan");
  int keysFound = 0;
  List<AtKey> response;

  ClientSdkService client = ClientSdkService.getInstance();
  response = await client.getAtKeys();

  // Instantiating a list of strings
  List<String> responseList = [];
  globalUIEvents.clear();


  for (AtKey atKey in response) {


    String value = await lookup(atKey);
    print("Key:"+atKey.toString());
    print("Key Value:" + value);

    Map<String, dynamic> jsonValue = json.decode(value);
    EventNotificationModel eventModel = EventNotificationModel.fromJson(jsonValue);

    globalUIEvents.add(eventModel.toUI_Event());
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