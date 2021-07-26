import 'package:at_common_flutter/services/size_config.dart';

import '../Widgets/custom_toast.dart';
import '../Widgets/input_field.dart';
import 'package:at_event/Widgets/location_tile.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/location_modal/location_modal.dart';
import 'package:at_location_flutter/service/my_location.dart';
import 'package:flutter/material.dart';
import 'package:at_event/screens/selected_location.dart';
import 'event_create_screen.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:latlong2/latlong.dart';

class SelectLocation extends StatefulWidget {
  SelectLocation({required this.createScreen});

  final EventCreateScreen createScreen;

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String inputText = '';
  String activeAtSign = '';
  bool isLoader = false;
  LatLng? currentLocation;
  bool? nearMe;
  @override
  void initState() {
    getAtSign();
    calculateLocation();
    super.initState();
  }

  /// nearMe == null => loading
  /// nearMe == false => dont search nearme
  /// nearMe == true => search nearme
  /// nearMe == false && currentLocation == null =>dont search nearme
  // ignore: always_declare_return_types
  calculateLocation() async {
    currentLocation = await getMyLocation();
    if (currentLocation != null) {
      nearMe = true;
    } else {
      nearMe = false;
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig().screenHeight * 0.8,
      padding: EdgeInsets.fromLTRB(28.toWidth, 20.toHeight, 17.toWidth, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InputField(
                  hintText: 'Search an area, street name…',
                  initialValue: inputText,
                  onSubmitted: (String str) async {
                    setState(() {
                      isLoader = true;
                    });
                    // ignore: await_only_futures
                    if ((nearMe == null) || (!nearMe!)) {
                      // ignore: await_only_futures
                      SearchLocationService().getAddressLatLng(str, null);
                    } else {
                      // ignore: await_only_futures
                      SearchLocationService()
                          .getAddressLatLng(str, currentLocation!);
                    }
                    setState(() {
                      isLoader = false;
                    });
                  },
                  value: (val) {
                    inputText = val;
                  },
                  icon: Icons.search,
                  onIconTap: () async {
                    setState(() {
                      isLoader = true;
                    });
                    // ignore: await_only_futures
                    if ((nearMe == null) || (!nearMe!)) {
                      // ignore: await_only_futures
                      SearchLocationService().getAddressLatLng(inputText, null);
                    } else {
                      // ignore: await_only_futures
                      SearchLocationService()
                          .getAddressLatLng(inputText, currentLocation!);
                    }
                    setState(() {
                      isLoader = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 10.toWidth),
              Column(
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: kNormalTextStyle.copyWith(
                            color: kColorStyle3,
                          ))),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.toHeight),
          Row(
            children: <Widget>[
              Checkbox(
                value: nearMe,
                tristate: true,
                onChanged: (value) async {
                  if (nearMe == null) return;

                  if (!nearMe!) {
                    currentLocation = await getMyLocation();
                  }

                  if (currentLocation == null) {
                    CustomToast().show('Unable to access location', context);
                    setState(() {
                      nearMe = false;
                    });
                    return;
                  }

                  setState(() {
                    nearMe = !nearMe!;
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Near me', style: kNormalTextStyle),
                    ((nearMe == null) ||
                            ((nearMe == false) && (currentLocation == null)))
                        ? Flexible(
                            child: Text('(Cannot access location permission)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kNormalTextStyle.copyWith(
                                    color: Colors.red, fontSize: 12.0)),
                          )
                        : SizedBox()
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.toHeight,
          ),
          Divider(),
          SizedBox(height: 18.toHeight),
          InkWell(
              onTap: () async {
                if (currentLocation == null) {
                  CustomToast().show('Unable to access location', context);
                  return;
                }
                onLocationSelect(context, currentLocation);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Location',
                      style: kNormalTextStyle.copyWith(
                          fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 5.toHeight),
                  Text('Using GPS',
                      style: kNormalTextStyle.copyWith(
                          fontSize: 12, color: Colors.grey)),
                ],
              )),
          SizedBox(height: 20.toHeight),
          Divider(),
          SizedBox(height: 20.toHeight),
          isLoader
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
          StreamBuilder(
            stream: SearchLocationService().atLocationStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<LocationModal>> snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? SizedBox()
                  : snapshot.hasData
                      ? snapshot.data!.isEmpty
                          ? Text('No such location found')
                          : Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data!.length,
                                separatorBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Divider(),
                                    ],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => onLocationSelect(
                                      context,
                                      LatLng(
                                          double.parse(
                                              snapshot.data![index].lat!),
                                          double.parse(
                                              snapshot.data![index].long!)),
                                      displayName:
                                          snapshot.data![index].displayName,
                                    ),
                                    child: LocationTile(
                                      icon: Icons.location_on,
                                      title: snapshot.data![index].city,
                                      subTitle:
                                          snapshot.data![index].displayName,
                                    ),
                                  );
                                },
                              ),
                            )
                      : snapshot.hasError
                          ? Text('Something Went wrong')
                          : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
    initializeLocationService(
      VentoService.getInstance().atClientServiceInstance!.atClient!,
      activeAtSign,
      NavService.navKey,
      apiKey: MixedConstants.HERE_API_KEY,
      mapKey: MixedConstants.MAP_KEY,
    );
  }

  void onLocationSelect(BuildContext context, LatLng? point,
      {String? displayName}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectedLocation(
                  createScreen: widget.createScreen,
                  displayName: displayName ?? 'Your location',
                  point: point,
                )));
  }
}

class NavService {
  static GlobalKey<NavigatorState> navKey = GlobalKey();
}
