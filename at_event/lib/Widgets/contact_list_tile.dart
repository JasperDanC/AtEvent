/// This widget is a list tile to display contacts selected for sharing
/// it takes [onlyRemovemethod] as a boolean with default value as [false]
/// if [true] trailing icon remains [close] icon [onAdd] method is disabled
/// all [isSelected] functionalities are disabled

import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';

class ContactListTile extends StatefulWidget {
  final String? name;
  final String? atSign;
  final Widget? image;
  final Function? onAdd;
  final Function? onRemove;
  final bool? isSelected;
  final bool? onlyRemoveMethod;
  final Function? onTileTap;
  final bool? plainView;
  const ContactListTile(
      {this.name,
      this.atSign,
      this.image,
      this.onAdd,
      this.onRemove,
      this.isSelected,
      this.onlyRemoveMethod,
      this.onTileTap,
      this.plainView});

  @override
  _ContactListTileState createState() => _ContactListTileState();
}

class _ContactListTileState extends State<ContactListTile> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: widget.onlyRemoveMethod!
            ? () {
                widget.onTileTap!();
              }
            : () {
                setState(() {
                  selected = !selected;
                  !selected ? widget.onRemove!() : widget.onAdd!();
                });
              },
        title: Text(
          widget.name!,
          style: kNormalTextStyle,
        ),
        subtitle: Text(
          widget.atSign!,
          style: kNormalTextStyle,
        ),
        trailing: widget.plainView!
            ? Container()
            : widget.isSelected!
                ? GestureDetector(
                    onTap: () {
                      widget.onRemove!();
                    },
                    child: Icon(
                      Icons.close,
                      color: kGreyishWhite,
                    ),
                  )
                : Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
        leading: Stack(
          children: [
            Container(
              height: 40.toWidth,
              width: 40.toWidth,
              decoration: BoxDecoration(
                color: kColorStyle3,
                shape: BoxShape.circle,
              ),
              child: widget.image,
            ),
            Positioned(
              child: widget.onlyRemoveMethod!
                  ? Container()
                  : Container(
                      height: 15.toHeight,
                      width: 15.toHeight,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isSelected!
                              ? Colors.black
                              : Colors.transparent),
                      child: widget.isSelected!
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10.toHeight,
                            )
                          : Container(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
