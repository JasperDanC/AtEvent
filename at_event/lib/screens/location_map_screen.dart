import 'package:at_event/Widgets/floating_icon.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lon;

  const MapScreen({this.lat, this.lon});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String activeAtSign = '';
  void initState() {
    getAtSign();
    super.initState();
  }

  Widget build(BuildContext context) {
    var mapController = MapController();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            showLocation(UniqueKey(), mapController,
                location: LatLng(widget.lat!, widget.lon!)),
            Positioned(
              top: 0,
              left: 0,
              child: FloatingIcon(
                bgColor: kGreyishWhite,
                icon: Icons.arrow_back,
                iconColor: Colors.black,
                isTopLeft: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    activeAtSign = currentAtSign!;
    setState(() {});
    initializeLocationService(
      VentoService.getInstance().atClientServiceInstance!.atClient!,
      activeAtSign,
      NavService.navKey,
      apiKey: MixedConstants.HERE_API_KEY,
      mapKey: MixedConstants.MAP_KEY,
    );
  }
}

class NavService {
  static GlobalKey<NavigatorState> navKey = GlobalKey();
}
