import 'package:flutter/material.dart';
import 'package:at_common_flutter/at_common_flutter.dart';

/// Floating IconButton widget
///
class FloatingIcon extends StatelessWidget {
  final Color bgColor, iconColor;
  final IconData icon;
  final bool isTopLeft;
  final Function onPressed;

  FloatingIcon(
      {this.bgColor,
      this.icon,
      this.iconColor,
      this.isTopLeft = false,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.toHeight,
      width: 50.toHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: !isTopLeft ? Radius.circular(10.0) : Radius.circular(0),
          bottomRight: isTopLeft ? Radius.circular(10.0) : Radius.circular(0),
        ),
        color: bgColor ?? Colors.black,
        boxShadow: [
          BoxShadow(
            color: iconColor ?? Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: IconButton(
          padding: EdgeInsets.all(10.toHeight),
          icon: Icon(
            icon ?? Icons.table_rows,
            color: iconColor ?? Colors.white,
            size: 27.toFont,
          ),
          onPressed: onPressed ?? () => Scaffold.of(context).openEndDrawer()),
    );
  }
}
