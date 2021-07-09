import 'package:at_event/Widgets/custom_toast.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'dart:math';
import 'package:at_event/Widgets/invite_box.dart';

class GroupInformation extends StatelessWidget {
  final GroupModel group;
  const GroupInformation({this.group});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0),
                height: SizeConfig().screenHeight * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/group_landscape.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: SizeConfig().screenHeight * 0.5,
                padding: EdgeInsets.all(40.0),
                width: SizeConfig().screenWidth,
                decoration: BoxDecoration(
                  color: kGroupInfoImageBackground.withOpacity(0.7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    Container(
                      width: 90.0,
                      child: Divider(
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      group.title,
                      style: kTitleTextStyle.copyWith(fontSize: 35.0),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Capacity Indicator: For now it will just be a random generated value until we can implement capacity functions to our groups
                        Expanded(
                          child: Container(
                            child: LinearProgressIndicator(
                              backgroundColor:
                                  Color.fromRGBO(209, 224, 224, 0.2),
                              value: generateRandomDouble(Random(), 0.0, 1.0),
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Capacity',
                              style: kNormalTextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              color: kColorStyle1.withOpacity(0.5),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                  'Total:\n  ' + generateRandomCapacity(),
                                  style: kSubHeadingTextStyle.copyWith(
                                      fontSize: 20.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: SizeConfig().screenHeight * 0.5,
            width: SizeConfig().screenWidth,
            decoration: BoxDecoration(color: kColorStyle1),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    group.description,
                    style: kNormalTextStyle.copyWith(
                        fontSize: 18.0, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    color: kColorStyle2,
                    shape: StadiumBorder(),
                    elevation: 0.1,
                    child: Text('Show Members', style: kButtonTextStyle),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: SizeConfig().screenHeight * 2.0,
                            decoration: BoxDecoration(
                              color: kColorStyle3,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InviteBox(
                                  invitees: group.atSignMembers,
                                  onAdd: (){
                                    CustomToast()
                                        .show('Invite Sent!', context);
                                  },
                                  width: 300,
                                  height: 300,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double generateRandomDouble(Random source, num start, num end) {
    num result;
    result = source.nextDouble() * (end - start) + start;
    return result;
  }

  String generateRandomCapacity() {
    Random random = Random();
    int rndNum = random.nextInt(101);
    return rndNum.toString();
  }
}
