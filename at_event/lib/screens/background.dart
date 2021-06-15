import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/utils/constants.dart';
import '../service/client_sdk_service.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';

class Background extends StatefulWidget {
  Background({this.child, this.turnAppbar = true, this.loggedIn = true});
  final Widget child;
  final bool turnAppbar;
  final bool loggedIn;


  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  ClientSdkService clientSdkService = ClientSdkService.getInstance();

  String activeAtSign = '';

  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  void initState() {
    if(widget.loggedIn) {
      getAtSignAndInitContacts();
    }
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: widget.turnAppbar
          ? AppBar(
              toolbarHeight: 65.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45.0),
                bottomLeft: Radius.circular(45.0),
              )),
              centerTitle: true,
              backgroundColor: kPrimaryBlue,
              title: Text(
                "@Vento",
                style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          : null,
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(start: 0.0, end: 0.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: [
                    const Color(0xff171616),
                    const Color(0xff1b1a1a),
                    const Color(0xff727272),
                    const Color(0xff808080)
                  ],
                  stops: [0.0, 0.0, 0.46, 1.0],
                ),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: widget.turnAppbar ? 120 : 0,
              ),
              widget.child
            ],
          )
        ],
      ),
      drawer: widget.loggedIn
          ? Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Your Invitations"),
                    onTap: () {
                      Navigator.pushNamed(context, '/InvitationsScreen');
                    },
                  ),
                  ListTile(
                    title: Text("Contacts"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ContactsScreen(),
                      ));
                    },
                  ),
                  ListTile(
                    title: Text("Blocked"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BlockedScreen(),
                      ));
                    },
                  ),
                ],
              ),
            )
          : null,
      extendBodyBehindAppBar: true,
    );
  }

  getAtSignAndInitContacts() async {
    String currentAtSign = await ClientSdkService.getInstance().getAtSign();

    activeAtSign = currentAtSign;
    initializeContactsService(clientSdkService.atClientInstance, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }
}
