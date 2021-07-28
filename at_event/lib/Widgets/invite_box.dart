import 'package:at_contact/at_contact.dart';
import 'package:at_contacts_flutter/services/contact_service.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// UI Widget designed to display all of the atsigns invited to our event/group
/// has a function [onAdd] designed to create functionality to integrate multiple invitation boxes.

//ignore: must_be_immutable
class InviteBox extends StatefulWidget {
  InviteBox(
      {required this.invitees,
      this.onAdd,
      required this.width,
      required this.height,
      required this.addToList,
      required this.isCreator});
  final bool isCreator;
  final double width;
  final double height;
  final List<String?> invitees;
  Function? onAdd;
  final bool addToList;
  final TextEditingController controller = TextEditingController();

  @override
  _InviteBoxState createState() => _InviteBoxState();
}

class _InviteBoxState extends State<InviteBox> {
  final ScrollController _scrollController = ScrollController();
  String? _inviteeAtSign;
  String activeAtSign = '';
  List<String> contactNames = [];

  getAtSignAndInitContacts() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();

    activeAtSign = currentAtSign!;
    initializeContactsService(
        VentoService.getInstance().atClientInstance!, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
    List<AtContact?> contacts = await ContactService().fetchContacts();
    print(contacts.length);
    for (AtContact? c in contacts) {
      if (c != null) {
        contactNames.add(c.atSign!);
      } else {
        print('null contact');
      }
    }
  }

  @override
  void initState() {
    getAtSignAndInitContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(contactNames);
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: widget.isCreator
                ? [
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      onPressed: () {
                        if (_inviteeAtSign != null) {
                          List<String> withoutAtSigns = [];
                          for (String? sign in widget.invitees) {
                            withoutAtSigns.add(sign!.replaceAll("@", ""));
                          }
                          setState(() {
                            if (!withoutAtSigns.contains(
                                _inviteeAtSign!.replaceAll("@", ""))) {
                              if (widget.addToList) {
                                widget.invitees.add(_inviteeAtSign);
                              }
                              widget.onAdd!();
                              widget.controller.clear();
                            }
                          });
                        }
                      },
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    Text(
                      '@',
                      style: TextStyle(color: Color(0xFFaae5e6), fontSize: 22),
                    ),
                    Expanded(
                        child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        onChanged: (value) {
                          _inviteeAtSign = value;
                        },
                        keyboardType: TextInputType.text,
                        controller: widget.controller,
                        cursorColor: Colors.white,
                        style: kEventDetailsTextStyle,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion as String),
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        widget.controller.text = suggestion.replaceAll('@', '');
                        _inviteeAtSign = suggestion.replaceAll('@','');
                      },
                      suggestionsCallback: (String pattern) {
                        List<String> suggestions = [];
                        for (String name in contactNames) {
                          String nameWithoutAt = name.replaceAll('@','');
                          if (nameWithoutAt.startsWith(pattern.replaceAll('@', ''))) {
                            suggestions.add(name);
                          }
                        }
                        return suggestions;
                      },
                      // child: TextField(
                      //   onChanged: (value) {
                      //     _inviteeAtSign = value;
                      //   },
                      //   keyboardType: TextInputType.text,
                      //   autofillHints: contactNames,
                      //   controller: widget.controller,
                      //   cursorColor: Colors.white,
                      //   style: kEventDetailsTextStyle,
                      //   decoration: InputDecoration(
                      //     enabledBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.white)),
                      //     focusedBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.white)),
                      //   ),
                      // ),
                    )),
                  ]
                : [],
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: kForegroundGrey,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                      controller: _scrollController,
                      itemCount: widget.invitees.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.invitees[index]!.startsWith("@")
                                ? widget.invitees[index]!
                                : "@" + widget.invitees[index]!,
                            style: kEventDetailsTextStyle,
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
