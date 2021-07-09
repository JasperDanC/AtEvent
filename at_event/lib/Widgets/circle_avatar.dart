import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String image;
  final bool nonAsset;
  final File fileImage;

  const CustomCircleAvatar(
      {Key key, this.image, this.nonAsset = false, this.fileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: CircleAvatar(
        backgroundColor: kColorStyle1,
        radius: 35,
        child: CircleAvatar(
          backgroundColor: kColorStyle2,
          radius: 30,
          child: nonAsset
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image.file(
                    fileImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: kColorStyle3,
                  radius: 25,
                  backgroundImage: AssetImage(image),
                ),
        ),
      ),
    );
  }
}
