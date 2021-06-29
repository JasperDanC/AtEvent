import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:at_event/Widgets/custom_toast.dart';
import 'package:at_event/Widgets/floating_icon.dart';
import 'package:at_event/Widgets/input_field.dart';
import 'package:at_event/models/event_datatypes.dart';
import 'package:at_event/service/event_services.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'event_create_screen.dart';

class SelectedLocation extends StatefulWidget {
  final LatLng point;
  String displayName;
  final EventCreateScreen createScreen;

  SelectedLocation({this.displayName, this.point, @required this.createScreen});

  @override
  _SelectedLocationState createState() => _SelectedLocationState();
}

class _SelectedLocationState extends State<SelectedLocation> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ShowLocation(UniqueKey(), location: LatLng(widget.point.latitude, widget.point.longitude)),
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
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                    28.toWidth, 20.toHeight, 28.toHeight, 0),
                height: SizeConfig().screenHeight * 0.4,
                width: SizeConfig().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: kColorStyle2,
                              ),
                              Text('',
                                  style:
                                      kNormalTextStyle.copyWith(fontSize: 16))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Text('Cancel', style: kNormalTextStyle),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.toHeight),
                    Text('Label', style: kNormalTextStyle),
                    SizedBox(height: 5.toHeight),
                    InputField(
                      width: 321.toWidth,
                      hintText: 'Save this address as',
                      // TODO: Set Initial Value to setting
                      initialValue: widget.displayName,
                      value: (String val) {
                        widget.displayName = val;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 20.toHeight),
                child: CustomButton(
                    buttonText: 'Save',
                    onPressed: () {
                      if ((widget.displayName != null) && widget.displayName.isNotEmpty) {
                        Setting setting = Setting()
                        ..label = widget.displayName
                        ..latitude = widget.point.latitude
                        ..longitude = widget.point.longitude;
                        setState(() {
                          widget.createScreen.setting = setting;
                          widget.createScreen.locationController.text=setting.label;
                        });

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        CustomToast()
                            .show('Cannot leave label empty!', context);
                      }
                    },
                    width: 165.toHeight,
                    height: 48.toHeight,
                    buttonColor: kColorStyle2,
                    fontColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
