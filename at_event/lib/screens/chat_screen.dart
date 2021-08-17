import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_event/service/vento_services.dart';


class VentoChatScreen extends StatefulWidget {
  VentoChatScreen({required this.groupMembers, required this.chatID});
  final List<String> groupMembers;
  //since chat will be from a event or a group the chatID will be
  // the atKey key name of the event or group
  final String chatID;
  @override
  _VentoChatScreenState createState() => _VentoChatScreenState();
}

class _VentoChatScreenState extends State<VentoChatScreen> {
  String activeAtSign = '';
  
  @override
  void initState() {
    getAtSignAndInitializeChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Screen')),
      body: ChatScreen(
        height: MediaQuery.of(context).size.height,
        incomingMessageColor: kColorStyle2,
        outgoingMessageColor:kPrimaryBlue,
        isScreen: true,
      ),
    );
  }
  void getAtSignAndInitializeChat() async {
    var currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
    initializeChatService(
        VentoService.getInstance().atClientServiceInstance!.atClient!, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
    
    setChatWithAtSign(null, isGroup: true,groupId: widget.chatID,groupMembers: widget.groupMembers);
  }
}