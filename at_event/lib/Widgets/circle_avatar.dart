
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';

/// Returns a Custom Circle Avatar that has the option to contain an asset image
/// and a file image chosen from your phone directly.
///
///
///

class CustomCircleAvatar extends StatelessWidget {
  final String? image;
  final bool nonAsset;
  final String? url;

  const CustomCircleAvatar(
      {Key? key, this.image, this.nonAsset = false, this.url})
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
          child: url != null && url!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image.network(
                    url!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: kColorStyle3,
                  radius: 25,
                  backgroundImage: AssetImage(image!),
                ),
        ),
      ),
    );
  }
}
