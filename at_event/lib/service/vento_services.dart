import 'dart:convert';
import 'dart:core';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_event/models/invite.dart';
import '../utils/constants.dart' as conf;

class VentoService {
  static final VentoService _singleton = VentoService._internal();

  VentoService._internal();

  factory VentoService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  AtClientImpl? atClientInstance;
  Map<String?, AtClientService?> atClientServiceMap = {};
  String? _atsign;
  late BuildContext _currentKnownContext;

  _reset() {
    atClientServiceInstance = null;
    atClientInstance = null;
    atClientServiceMap = {};
    _atsign = null;
  }

  _sync() async {
    await _getAtClientForAtsign()!.getSyncManager()!.sync();
  }

  AtClientImpl? _getAtClientForAtsign({String? atsign}) {
    atsign ??= _atsign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign]!.atClient;
    }
    return null;
  }

  void updateContext(BuildContext context) {
    _currentKnownContext = context;
  }

  AtClientService? _getClientServiceForAtSign(String? atsign) {
    if (atsign == null) {}
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    return AtClientService();
  }

  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    final appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    var _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.MixedConstants.NAMESPACE
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = conf.MixedConstants.ROOT_DOMAIN
      ..syncRegex = conf.MixedConstants.regex
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  _checkAtSignStatus(String atsign) async {
    var atStatusImpl = AtStatusImpl(rootUrl: conf.MixedConstants.ROOT_DOMAIN);
    var status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  Future<bool> onboard({String? atsign}) async {
    // atClientServiceInstance = AtClientService();
    atClientServiceInstance = _getClientServiceForAtSign(atsign);
    // atClientServiceInstance = _getClientServiceForAtSign(atClientServiceInstance.);

    var atClientPreference = await getAtClientPreference();
    var result = await atClientServiceInstance!.onboard(
        atClientPreference: atClientPreference, atsign: atsign);
    _atsign = atsign == null ? await this.getAtSign() : atsign;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance);
    _sync();
    return result;
  }

  ///Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  Future<bool> authenticate(
    String atsign, {
    String? privateKey,
    String? jsonData,
    String? decryptKey,
  }) async {
    var atsignStatus = await _checkAtSignStatus(atsign);
    if (atsignStatus != ServerStatus.teapot &&
        atsignStatus != ServerStatus.activated) {
      throw atsignStatus;
    }
    var atClientPreference = await getAtClientPreference();
    var result = await atClientServiceInstance!.authenticate(
        atsign, atClientPreference,
        jsonData: jsonData, decryptKey: decryptKey);
    _atsign = atsign;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance);
    await _sync();
    return result;
  }

  String generateKeyName(String activeAtSign, conf.KeyType type) {
    return '${conf.KeyConstants.keyStringMap[type]}.${activeAtSign.replaceAll("@", "")}.${DateTime.now().millisecondsSinceEpoch}';
  }

  String getCreatorOfKey(AtKey key) {
    List<String> keyParts = key.key!.split('.');
    print(key.key);
    print(keyParts);
    return keyParts[1];
  }

  Future<bool> startMonitor(currentAtSign) async {
    var privateKey = await (getPrivateKey(currentAtSign) as Future<String>);

    await _getAtClientForAtsign()!.startMonitor(privateKey, _callback);
    print('Monitor started');
    return true;
  }

  Future<void> _callback(dynamic response) async {
    print('fnCallBack called in vento service');

    //translates the notification to its operation and atKey
    List translated = _translateResponseToKey(response);
    String? operation = translated[0];
    AtKey notifKey = translated[1];


    //if the notification was sent to yourself ignore it.
    bool sentToSelf = compareAtSigns(notifKey.sharedBy!, notifKey.sharedWith!);
    //if the notification was sent by null ignore it.
    bool nullNotif = notifKey.sharedBy == null || notifKey.sharedBy == 'null';
    //ignores those two circumstances
    if (sentToSelf || nullNotif) return;

    print('_callback operation $operation');
    switch (operation) {
      case 'delete':
        _handleDeleteNotif(notifKey);
        break;
      case 'update':
        conf.KeyType? type = getKeyType(notifKey);
        print("got notif of type " + type.toString());
        switch (type) {
          case conf.KeyType.EVENT:
            String? value = await lookup(notifKey);
            print("Notification Value: " + value.toString());
            Provider.of<UIData>(_currentKnownContext, listen: false)
                .clearAcceptedGroups();
            await put(notifKey, value);
            scan(_currentKnownContext);
            return;
          case conf.KeyType.GROUP:
            String? value = await lookup(notifKey);
            print("Notification Value: " + value.toString());
            Provider.of<UIData>(_currentKnownContext, listen: false)
                .clearAcceptedEvents();
            await VentoService.getInstance().put(notifKey, value);
            scan(_currentKnownContext);
            return;
          case conf.KeyType.CONFIRMATION:
            _handleConfirm(notifKey);
            break;
          case conf.KeyType.PROFILE_PIC:
            // Profile pic not yet implemented
            // Also I imagine that when implemented people won't send
            // them as notifications
            break;
          case null:
            break;
        }
        break;
    }
  }

  void _handleConfirm(AtKey notifKey) async {
    print("got confirmation " + notifKey.key!);
    String keyOfObject =
        notifKey.key!.replaceFirst(conf.KeyConstants.confirmStart, "");

    //create a replacement atKey to update the peopleGoing
    Metadata metadata = Metadata()..ccd = true;
    AtKey atKeyOfObject = AtKey()
      ..key = keyOfObject
      ..metadata = metadata
      ..sharedWith = notifKey.sharedWith
      ..sharedBy = notifKey.sharedWith;

    //get the original event
    String value = await (lookup(atKeyOfObject) as Future<String>);
    Map<String, dynamic>? jsonValue = json.decode(value);

    conf.KeyType? type = getKeyType(atKeyOfObject);

    // ignore other types of keys as you cant confirm profile pics
    // or confirmations
    // ignore: missing_enum_constant_in_switch
    switch (type) {
      case conf.KeyType.EVENT:
        EventNotificationModel eventModel =
            EventNotificationModel.fromJson(jsonValue!);

        //add the person who confirmed to the event
        eventModel.peopleGoing.add(notifKey.sharedBy!);

        //convert to back to string
        value =
            EventNotificationModel.convertEventNotificationToJson(eventModel);

        //update on the secondary
        await put(atKeyOfObject, value);
        await shareWithMany(atKeyOfObject.key, value, atKeyOfObject.sharedBy,
            eventModel.invitees);
        break;
      case conf.KeyType.GROUP:
        print("group confirmation");
        // get the group model
        GroupModel groupModel = GroupModel.fromJson(jsonValue!);
        // add the one who sent the confirmation to the members
        groupModel.atSignMembers.add(notifKey.sharedBy!);
        //convert back to string
        String updatedGroupValue = GroupModel.convertGroupToJson(groupModel);

        await put(atKeyOfObject, updatedGroupValue);
        await shareWithMany(keyOfObject, updatedGroupValue, atKeyOfObject.sharedBy,
            groupModel.invitees);

        var eventMetadata = Metadata()..ccd = true;
        print("sending all group events");
        //add the new group member to all events associated with group
        for (String key in groupModel.eventKeys) {
          print("sending event key: " + key);
          AtKey eventKey = AtKey()
            ..key = key
            ..metadata = eventMetadata
            ..sharedBy = notifKey.sharedWith
            ..sharedWith = notifKey.sharedWith;

          //get the event
          String value = await (lookup(eventKey) as Future<String>);
          Map<String, dynamic> jsonValue = json.decode(value);
          EventNotificationModel eventModel =
              EventNotificationModel.fromJson(jsonValue);

          //add the person
          eventModel.invitees.add(notifKey.sharedBy!);
          eventModel.peopleGoing.add(notifKey.sharedBy!);

          //retranslate to string
          String storedValue =
              EventNotificationModel.convertEventNotificationToJson(eventModel);

          //store for myself and all invitees
          await put(eventKey, storedValue);
          await shareWithMany(
              key, storedValue, notifKey.sharedWith, eventModel.invitees);
        }
        break;
    }
  }

  void _handleDeleteNotif(AtKey notifKey) async {
    String activeAtSign = notifKey.sharedWith!;
    String keyCreator = getCreatorOfKey(notifKey);
    bool isKeyCreator = compareAtSigns(activeAtSign, keyCreator);
    if (isKeyCreator) {
      //swap shared with and shared by
      String? temp = notifKey.sharedBy;
      notifKey.sharedBy = notifKey.sharedWith!.replaceAll("@", "");
      notifKey.sharedWith = temp;
      print('deleting event: ' + notifKey.toString());
      //delete the shared version of the key.
      // when a key is shared a separate shared version is made so we
      // gotta delete the shared version so it disappears on this secondary as
      // well as there person it was shared with
      await delete(notifKey);
      return;
    } else {
      //if I did not create this key and got the delete notification then all
      // i do is  delete the key
      await delete(notifKey);
      scan(_currentKnownContext);
      return;
    }
  }

  List _translateResponseToKey(dynamic response) {
    //remove notification specificier
    response = response.replaceFirst('notification:', '');
    //get the json from the response
    var responseJson = jsonDecode(response);

    //get all the important values from the json
    String notificationKey = responseJson['key'];
    String? fromAtSign = responseJson['from'];
    //var value = responseJson['value'];
    String? to = responseJson['to'];
    String atKey = notificationKey.split(':')[1];
    String? operation = responseJson['operation'];

    //create a real AtKey from data collected from the json
    AtKey realKey = AtKey.fromString(atKey);
    var metadata = Metadata()..ccd = true;

    realKey.sharedBy = fromAtSign;
    realKey.sharedWith = to;
    realKey.metadata = metadata;
    return [operation, realKey];
  }

  ///Fetches privatekey for [atsign] from device keychain.
  Future<String?> getPrivateKey(String atsign) async {
    return await _getAtClientForAtsign()!.getPrivateKey(atsign);
  }

  ///scans all keys and puts there data in the appropriate places in the data
  ///model of the app, returns the amount of keys scanned
  void scan(BuildContext context) async {
    print("Starting scan");
    _currentKnownContext = context;
    //gets the client sdk service to fill a list with all the atKeys
    List<AtKey> response = await getAtKeys();
    List<AtKey> groupAtKeys = [];
    List<AtKey> eventAtKeys = [];
    String? activeAtSign = await getAtSign();

    Provider.of<UIData>(context, listen: false).clear();
    print("Found ${response.length} keys");
    for (AtKey atKey in response) {
      print("Key:" + atKey.toString());
      //makes sure we do not save any keys that don't come from anyone
      //these keys only generate when something has gone wrong
      if (keySentByNull(atKey)) return;

      conf.KeyType? keyType = getKeyType(atKey);
      print("Key Type:" + keyType.toString());
      switch (keyType) {
        case conf.KeyType.EVENT:
          eventAtKeys.add(atKey);
          break;
        case conf.KeyType.GROUP:
          groupAtKeys.add(atKey);
          break;
        case conf.KeyType.CONFIRMATION:
          // confirmation keys do not get scanned into the apps data
          // only used for the notification callback
          break;
        case conf.KeyType.PROFILE_PIC:
          // Profile Pictures not yet implement on secondary server
          break;
        case null:
          print("Got key with null type");
          break;
      }
    }

    //handle all the groupKeys first so that events can properly find out if they have the group
    for(AtKey groupAtKey in groupAtKeys){
      handleGroupKey(groupAtKey, activeAtSign);
    }
    for(AtKey eventAtKey in eventAtKeys){
      handleEventKey(eventAtKey, activeAtSign);
    }

    //these two loops add all accepted invites that are not yet stored as keys
    for (EventInvite ei
        in Provider.of<UIData>(context, listen: false).acceptedEventInvites) {
      if (!Provider.of<UIData>(context, listen: false).isAddedEvent(ei.event)) {
        Provider.of<UIData>(context, listen: false).addEvent(ei.event);
      }
    }
    for (GroupInvite gi
        in Provider.of<UIData>(context, listen: false).acceptedGroupInvites) {
      if (!Provider.of<UIData>(context, listen: false).isAddedGroup(gi.group)) {
        Provider.of<UIData>(context, listen: false).addGroup(gi.group);
      }
    }
  }

  ///handles putting keys/values for groups in the ui
  void handleGroupKey(AtKey groupKey, String? activeAtSign) async {
    //looks up the value which is stored as a json string
    String? value = await lookup(groupKey);

    //deletes the key if it is a duplicated event that shouldn't exist
    if (isDuplicatedGroupKey(activeAtSign, groupKey)) {
      print("bad key");
      await delete(groupKey);
      return;
    }
    print("Key Value:" + value.toString());
    //decode the json string into a json map
    Map<String, dynamic> jsonValue = json.decode(value!);
    GroupModel groupModel = GroupModel.fromJson(jsonValue);

    // saves all the important names (+other important vars)
    // and removes any existing @ symbols so that
    // finding out if this is a group the active has is straight forward
    String eventMaker = groupModel.atSignCreator.replaceAll("@", "");
    String sharedWith = groupKey.sharedWith!.replaceAll("@", "");
    List<String> members = [
      for (var x in groupModel.atSignMembers) x.replaceAll("@", "")
    ];
    String currentUser = activeAtSign!.replaceAll("@", "");

    //figures out if this is a group the active user has
    List<bool> isSharedAndMyGroup = isGoingToKey(
        keyMaker: eventMaker,
        sharedWith: sharedWith,
        goingMembers: members,
        activeAtSign: currentUser,
        isEventAndHasGroup: false);

    if (isSharedAndMyGroup[1]) {
      //adds it to groups in the ui
      Provider.of<UIData>(_currentKnownContext, listen: false)
          .addGroup(groupModel);
    } else if (!isSharedAndMyGroup[0]) {
      //adds it as an invite
      GroupInvite newInvite =
          GroupInvite(group: groupModel, from: groupModel.atSignCreator);

      //makes sure it isn't a deleted group before adding it
      bool isDeletedInvite =
          Provider.of<UIData>(_currentKnownContext, listen: false)
              .isDeletedGroupInvite(newInvite);

      if (!isDeletedInvite) {
        print("adding invite " + newInvite.group.title);
        Provider.of<UIData>(_currentKnownContext, listen: false)
            .addGroupInvite(newInvite);
      }
    }
  }

  ///places the key of an event in the UIData provider
  void handleEventKey(AtKey eventKey, String? activeAtSign) async {
    //deletes the key if it is a duplicated event that shouldn't exist
    if (isDuplicatedEventKey(activeAtSign, eventKey)) {
      await delete(eventKey);
      return;
    }

    //looks up the value which is stored as a json string
    String value = await (lookup(eventKey) as Future<String>);


    print("Key Value:" + value.toString());
    //decode the json string into a json map
    Map<String, dynamic> jsonValue = json.decode(value);
    //make the event Model from the json
    EventNotificationModel eventModel =
        EventNotificationModel.fromJson(jsonValue);
    // saves all the important names (+other important vars)
    // and removes any existing @ symbols so that
    // finding out if this is a calendar event is straight forward
    String eventMaker = eventModel.atSignCreator.replaceAll("@", "");
    String sharedWith = eventKey.sharedWith!.replaceAll("@", "");
    List<String> peopleGoing = [
      for (var x in eventModel.peopleGoing) x.replaceAll("@", "")
    ];
    String currentSign = activeAtSign!.replaceAll("@", "");

    bool eventWithGroup = false;
    //if the current event is in a group the user has
    if (eventModel.groupKey != '' &&
        eventModel.groupKey != null &&
        eventModel.groupKey != 'null') {
      eventWithGroup = Provider.of<UIData>(_currentKnownContext, listen: false)
          .hasGroupKey(eventModel.groupKey);
    }

    List<bool> isSharedAndIsMyEvent = isGoingToKey(
        keyMaker: eventMaker,
        sharedWith: sharedWith,
        goingMembers: peopleGoing,
        activeAtSign: currentSign,
        isEventAndHasGroup: eventWithGroup);

    if (isSharedAndIsMyEvent[1]) {
      //add it to the UIData as an event and then it will appear in the calendar
      Provider.of<UIData>(_currentKnownContext, listen: false)
          .addEvent(eventModel.toUIEvent());
    } else if (!isSharedAndIsMyEvent[0]) {
      //create an invite
      EventInvite newInvite = EventInvite(
          event: eventModel.toUIEvent(), from: eventModel.atSignCreator);

      // deleted invites that have not been deleted as keys can occur in the time
      //it takes to notify the event creator about deleting the event
      bool inviteWasDeleted =
          Provider.of<UIData>(_currentKnownContext, listen: false)
              .isDeletedEventInvite(newInvite);

      //add the invite if not deleted
      if (!inviteWasDeleted) {
        Provider.of<UIData>(_currentKnownContext, listen: false)
            .addEventInvite(newInvite);
      }
    }
  }

  ///Deletes All keys found for this atSign for this App
  ///Used for debugging purposes
  void deleteAll(BuildContext context) async {
    print("Starting to delete all Keys");
    _currentKnownContext = context;
    //keeps track of all keys deleted
    int keysDeleted = 0;
    //gets all the keys to delete
    List<AtKey> response = await getAtKeys();
    //clears UI
    Provider.of<UIData>(context, listen: false).clear();

    //loops through and deletes the keys
    for (AtKey atKey in response) {
      bool successful = await delete(atKey);
      if (successful) keysDeleted++;
    }
    print("Deleted $keysDeleted out of ${response.length} keys");
  }

  shareWithMany(
      String? key, String value, String? sharedBy, List<String> invitees) async {
    //metadata for the shared key
    var sharedMetadata = Metadata()
      ..ccd = true
      ..ttr = 40;
    for (String invitee in invitees) {
      if (!invitee.startsWith("@")) invitee = "@" + invitee;
      //key that comes from me and is shared with the added invitee
      AtKey sharedKey = AtKey()
        ..key = key
        ..metadata = sharedMetadata
        ..sharedBy = sharedBy
        ..sharedWith = invitee;

      //share that key and value
      await put(sharedKey, value);
    }
  }

  createAndShareEvent(EventNotificationModel event, String activeAtSign) async {
    //first we will deal with creating and storing the event on the secondary
    //server
    //create the @key
    AtKey atKey = AtKey();
    atKey.key = event.key;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = activeAtSign;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;

    String storedValue = EventNotificationModel.convertEventNotificationToJson(event);

    await put(atKey,storedValue);

    //now deal with sharing it with the group
    if(event.groupKey != ''){


      //AtKey for looking up and updating the group
      Metadata metadata = Metadata();
      metadata.ccd = true;
      AtKey groupKey = AtKey()
        ..key = event.groupKey
        ..sharedBy = activeAtSign
        ..sharedWith = activeAtSign;

      GroupModel group = await (lookupGroup(groupKey) as Future<GroupModel>);

      //make a list of group members other than the active user to share updated
      //group and event with the right people
      List<String> groupMembersExcludingMe = [];
      for (String member in group.atSignMembers) {
        if (!VentoService.getInstance().compareAtSigns(member, activeAtSign)) {
          groupMembersExcludingMe.add(member);
        }
      }
      //share the actual event with the right people
      await  shareWithMany(event.key, storedValue, activeAtSign, groupMembersExcludingMe);


      //now add the eventKey to the group
      group.eventKeys.add(event.key);

      //make a key and store the group in the secondary because we have updated
      //the eventKeys
      String groupValue = GroupModel.convertGroupToJson(group);
      await put(groupKey, groupValue);
      //share with group
      await shareWithMany(event.groupKey, groupValue, activeAtSign, groupMembersExcludingMe);


    }
  }

  ///Function for deciding if a event or group is not an invite.
  List<bool> isGoingToKey(
      {required String keyMaker,
      String? sharedWith,
      required List<String> goingMembers,
      required String activeAtSign,
      bool? isEventAndHasGroup}) {
    //active user is going to the event or group with this key
    bool activeIsGoing = goingMembers.contains(activeAtSign);
    //active made this event
    bool activeIsKeyMaker = compareAtSigns(activeAtSign, keyMaker);
    //active made this event and this key is the shared version. So the version
    //that an invitee has
    bool activeSharedThisKey =
        activeIsKeyMaker && !compareAtSigns(sharedWith!, activeAtSign);

    // it is a key that active has when active is going or
    // event is in a group that active has
    // and this isn't the shared version of the key.
    return [
      activeSharedThisKey,
      !activeSharedThisKey && (activeIsGoing || isEventAndHasGroup!)
    ];
  }

  ///occasionally when sending invitations the receiver will receive two keys
  ///one of these is a duplicated version that they have shared with themself
  /// this function marks if it is that type.
  bool isDuplicatedEventKey(String? activeAtSign, AtKey atKey) {
    if (compareAtSigns(atKey.sharedBy!, atKey.sharedWith!)) {
      return !compareAtSigns(activeAtSign!, getCreatorOfKey(atKey));
    }
    return false;
  }

  bool isDuplicatedGroupKey(String? activeAtSign, AtKey atKey) {
    if (compareAtSigns(atKey.sharedBy!, atKey.sharedWith!)) {
      return !compareAtSigns(activeAtSign!, getCreatorOfKey(atKey));
    }
    return false;
  }

  ///checks if two atSigns are the same. Not as simple as comparing strings as
  ///signs may appear with or without the @ symbol
  bool compareAtSigns(String sign1, String sign2) =>
      sign1.replaceAll("@", "") == sign2.replaceAll("@", "");

  ///checks a key's sharedBy if it is null.
  bool keySentByNull(AtKey atKey) =>
      atKey.sharedBy == 'null' || atKey.sharedBy == null;

  ///gets the type of the atKey e.i. is it a key for event? group?
  conf.KeyType? getKeyType(AtKey atKey) {
    String keyStart = atKey.key!.substring(0, 6);

    if (!conf.KeyConstants.keyTypeMap.containsKey(keyStart)) {
      return null;
    }
    return conf.KeyConstants.keyTypeMap[keyStart];
  }

  Future<String?> get(AtKey atKey) async {
    var result = await  _getAtClientForAtsign()!.get(atKey);
    return result.value;
  }

  /// Look up a value corresponding to an [AtKey] instance.
  /// basically just a wrapper for get function
  Future<String?> lookup(AtKey atKey) async {
    // If an AtKey object exists
    return await get(atKey);
  }

  Future<GroupModel?> lookupGroup(AtKey groupKey) async {
    String? stringValue = await lookup(groupKey);
    if (stringValue == null || stringValue == 'null') return null;
    print(stringValue);
    Map<String, dynamic> jsonValue = json.decode(stringValue);
    GroupModel groupModel = GroupModel.fromJson(jsonValue);
    return groupModel;
  }

  Future<bool> put(AtKey atKey, String? value) async {
    if (atKey.sharedWith != null) {
      if (!atKey.sharedWith!.startsWith("@"))
        atKey.sharedWith = "@" + atKey.sharedWith!;
    }
    if (atKey.sharedBy != null) {
      if (!atKey.sharedBy!.startsWith("@"))
        atKey.sharedBy = "@" + atKey.sharedBy!;
    }
    var result;
    try {
      result = await _getAtClientForAtsign()!.put(atKey, value);
    } catch (Exception) {
      result = await _getAtClientForAtsign()!.put(atKey, value);
    }
    return result;
  }

  Future<bool> delete(AtKey atKey) async {
    return await _getAtClientForAtsign()!.delete(atKey);
  }

  Future<List<AtKey>> getAtKeys({String? sharedBy, String? regex}) async {
    if (regex == null) {
      return await _getAtClientForAtsign()!
          .getAtKeys(regex: conf.MixedConstants.NAMESPACE, sharedBy: sharedBy);
    } else {
      return await _getAtClientForAtsign()!
          .getAtKeys(regex: regex, sharedBy: sharedBy);
    }
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await atClientServiceInstance!.getAtSign();
  }

  deleteAtSignFromKeyChain() async {
    // List<String> atSignList = await getAtsignList();
    String _atsign = atClientServiceInstance!.atClient!.currentAtSign!;

    await atClientServiceMap[_atsign]!.deleteAtSignFromKeychain(_atsign);

    _reset();
  }

  Future<bool> notify(
      AtKey atKey, String value, OperationEnum operation) async {
    return await _getAtClientForAtsign()!.notify(atKey, value, operation);
  }
}
