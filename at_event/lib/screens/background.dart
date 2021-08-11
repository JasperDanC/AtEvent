import 'package:at_event/screens/home_screen.dart';
import 'package:at_event/service/image_anonymous_authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/services.dart';
import '../service/vento_services.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import 'package:provider/provider.dart';
import 'package:at_event/models/ui_data.dart';
import 'package:badges/badges.dart';

class Background extends StatefulWidget {
  Background({this.child, this.turnAppbar = true, this.loggedIn = true});
  final Widget? child;
  final bool turnAppbar;
  final bool loggedIn;
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  VentoService clientSdkService = VentoService.getInstance();
  late AnonymousAuthService _auth;

  String activeAtSign = '';

  GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  void initState() {
    if (widget.loggedIn) {
      getAtSignAndInitContacts();
      _auth = AnonymousAuthService();
    }
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VentoService.getInstance().updateContext(context);
    String notifBadge = '';
    if(widget.loggedIn){
      notifBadge = (Provider.of<UIData>(context).groupInvitesLength + Provider.of<UIData>(context).eventInvitesLength).toString();
    }

    return MaterialApp(
      home: Scaffold(
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
                leading: IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => VentoHomeScreen(),),),),
                actions: <Widget>[MaterialButton(
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                  onPressed: () {
                    scaffoldKey!.currentState!.openDrawer();
                  },
                  child: Badge(
                    badgeContent: Text(notifBadge, style: kEventDetailsTextStyle,),
                    showBadge: int.parse(notifBadge) > 0 ,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),],
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
                    stops: [0.1, 0.2, 0.4, 0.8],
                  ),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: widget.turnAppbar ? 120 : 0,
                ),
                widget.child!
              ],
            )
          ],
        ),
        drawer: widget.loggedIn
            ? Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: Badge(
                        badgeContent: Text(notifBadge, style: kEventDetailsTextStyle,),
                        showBadge: int.parse(notifBadge) > 0 ,
                          child: Container(
                            width: double.infinity,
                            child: Text("Your Invitations", textAlign: TextAlign.start,),),),
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
                    // ListTile(
                    //   title: Text("Delete All Info on Secondary"),
                    //   onTap: () {
                    //     VentoService.getInstance().deleteAll(context);
                    //   },
                    // ),
                  ],
                ),
              )
            : null,
        extendBodyBehindAppBar: true,
      ),
    );
  }

  getAtSignAndInitContacts() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();

    activeAtSign = currentAtSign!;
    initializeContactsService(
        VentoService.getInstance().atClientInstance!, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }
}
