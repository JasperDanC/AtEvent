import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';


class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({
    Key key,
    @required int dropDownValue,
  }) : _dropDownValue = dropDownValue, super(key: key);

  final int _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Category:",
            style: kEventDetailsTextStyle,
          ),
        ),
        Expanded(
          child: DropdownButtonFormField(
            onChanged: (value){},
            value: _dropDownValue,
            items: [
              DropdownMenuItem(
                child: Text(
                  "No Category",
                ),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text(
                  "Music",
                ),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text(
                  "Sports",
                ),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text(
                  "Business",
                ),
                value: 4,
              ),
              DropdownMenuItem(
                child: Text(
                  "Party",
                ),
                value: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}