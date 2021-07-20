import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';

/// Returns a custom bottom sheet that can contain any child.
///
/// Function onSheetClosed should specify any additional actions that will be
/// taken after closing the bottom sheet

void bottomSheet(BuildContext context, T, double height,
    {Function? onSheetClosed}) {
  var future = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: StadiumBorder(),
      builder: (BuildContext context) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: kColorStyle1,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            ),
          ),
          child: T,
        );
      });

  future.then((value) {
    if (onSheetClosed != null) onSheetClosed();
  });
}
