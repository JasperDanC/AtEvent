import 'package:at_event/Widgets/invite_box.dart';
import 'package:at_event/main.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:at_event/screens/background.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/service/vento_services.dart';
import 'calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/group_model.dart';

import 'package:at_event/widgets/custom_toast.dart';

void main() => runApp(GroupCreateScreen());

class GroupCreateScreen extends StatefulWidget {
  @override
  _GroupCreateScreenState createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {

  VentoService clientSdkService;
  String _groupTitle;
  String _groupDesc;
  List<String> _invitees = [];
  String activeAtSign = '';

  TextEditingController _inviteTextController;

  @override
  void initState() {
    getAtSign();
    clientSdkService = VentoService.getInstance();
    _inviteTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: kColorStyle2, borderRadius: kBasicBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your New Group',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: kEventDetailsTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Group Title',
                    hintStyle: kEventDetailsTextStyle.copyWith(
                        color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    _groupTitle = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    cursorColor: Colors.white,
                    style: kEventDetailsTextStyle,
                    decoration: InputDecoration(
                      hintText: 'Group Description',
                      hintStyle: kEventDetailsTextStyle.copyWith(
                          color: Colors.grey[400]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onChanged: (value) {
                      _groupDesc = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                InviteBox(
                  invitees: _invitees,
                  onAdd: () {},
                  addToList: true,
                  width: 300,
                  height: 340,
                ),
                FloatingActionButton(
                  backgroundColor: kPrimaryBlue,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _update();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _update() async {
    //goes through and makes sure every field was set to something
    bool filled = _groupTitle != null &&
        _groupTitle != "" &&
        _groupDesc != null &&
        _groupDesc != "";
    if (filled) {
      GroupModel group = GroupModel()
        ..atSignCreator = activeAtSign
        ..key = VentoService.getInstance().generateKeyName(activeAtSign, KeyType.GROUP)
        ..title = _groupTitle
        ..description = _groupDesc
        ..imageURL = ''
        ..capacity = 50
        ..invitees = _invitees
        ..atSignMembers = [activeAtSign]
        ..eventKeys = [];

      //create the @key
      AtKey atKey = AtKey();
      atKey.key = group.key;
      atKey.sharedWith = activeAtSign;
      atKey.sharedBy = activeAtSign;
      Metadata metadata = Metadata();
      metadata.ccd = true;
      atKey.metadata = metadata;
      print(atKey.toString());

      //set the value to store in the secondary as the json version of the EventNotifications object
      String storedValue = GroupModel.convertGroupToJson(group);

      //put that shiza on the secondary
      await clientSdkService.put(atKey, storedValue);
      await VentoService.getInstance().shareWithMany(group.key, storedValue, activeAtSign, group.invitees);

      Provider.of<UIData>(context, listen: false).addGroup(group);
      //back to the calendar
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen()),
      );
    } else {
      //if they did not fill the fields print
      CustomToast()
          .show('Please fill all fields before creating the event', context);
    }
  }

  getAtSign() async {
    String currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
  }
}
