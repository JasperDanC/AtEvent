import 'package:at_common_flutter/services/size_config.dart';

import 'package:at_event/Widgets/custom_toast.dart';
import 'package:at_event/Widgets/input_field.dart';
import 'package:at_event/Widgets/location_tile.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/location_modal/location_modal.dart';
import 'package:at_location_flutter/service/my_location.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:at_event/screens/selected_location.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String inputText = '';
  bool isLoader = false;
  @override
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
                    await SearchLocationService().getAddressLatLng(str);
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
                    await SearchLocationService().getAddressLatLng(inputText);
                    setState(() {
                      isLoader = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 10.toWidth),
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: kNormalTextStyle.copyWith(
                        color: kColorStyle3,
                      ))),
            ],
          ),
          SizedBox(height: 20.toHeight),
          Divider(),
          SizedBox(height: 18.toHeight),
          InkWell(
              onTap: () async {
                var point = await getMyLocation();
                if (point == null) {
                  CustomToast().show('Unable to access location', context);
                  return;
                }
                onLocationSelect(context, point);
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
                      ? snapshot.data.isEmpty
                          ? Text('No such location found')
                          : Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data.length,
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
                                              snapshot.data[index].lat),
                                          double.parse(
                                              snapshot.data[index].long)),
                                      displayName:
                                          snapshot.data[index].displayName,
                                    ),
                                    child: LocationTile(
                                      icon: Icons.location_on,
                                      title: snapshot.data[index].city,
                                      subTitle:
                                          snapshot.data[index].displayName,
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
}

void onLocationSelect(BuildContext context, LatLng point,
    {String displayName}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectedLocation(
                displayName: displayName ?? 'Your location',
                point: point,
              )));
}
