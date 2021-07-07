import 'package:at_event/models/group_model.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'group_details.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'dart:math';

class GroupInformation extends StatelessWidget {
  final GroupModel group;
  const GroupInformation({this.group});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
          Column(children: [
            Container(
              height: SizeConfig().screenHeight * 0.5,
              width: SizeConfig().screenWidth,
              decoration: BoxDecoration(color: kColorStyle1),
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  group.description,
                  style: kNormalTextStyle.copyWith(
                      fontSize: 18.0, color: Colors.white),
                ),
              ),
            )
          ])
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
