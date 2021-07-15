import 'dart:convert';

class GroupModel {
  GroupModel();
  String title;
  String description;
  String imageURL;
  int capacity;
  List<String> eventKeys;
  List<String> atSignMembers;
  List<String> invitees;
  String atSignCreator;
  String key;

  GroupModel.fromJson(Map<String, dynamic> data) {
    title = data['title'] ?? '';
    key = data['key'] ?? '';
    imageURL = data['imageURL'] ?? '';
    //capacity = data['capacity'] ?? '';
    description = data['description'] ?? '';
    eventKeys = data['eventKeys'] == '[]' || data['eventKeys'] == ''
        ? []
        : data['eventKeys'].split(',') ?? [];
    atSignMembers = data['atSignMembers'] == '[]' || data['atSignMembers'] == ''
        ? []
        : data['atSignMembers'].split(',') ?? [];
    invitees = data['invitees'] == '[]' || data['invitees'] == ''
        ? []
        : data['invitees'].split(',') ?? [];
    atSignCreator = data['atSignCreator' ?? ''];
  }

  static String convertGroupToJson(GroupModel group) {
    var groupJson = json.encode({
      'title': group.title != null ? group.title.toString() : '',
      'imageURL': group.imageURL != null ? group.imageURL.toString() : '',
      //'capacity': group.capacity != null ? group.capacity.toString() : '',
      'description': group.description,
      'atSignCreator': group.atSignCreator.toString(),
      'invitees': group.invitees.length > 0 ? group.invitees.join(',') : '[]',
      'atSignMembers':
          group.atSignMembers.length > 0 ? group.atSignMembers.join(',') : '[]',
      'eventKeys':
          group.eventKeys.length > 0 ? group.eventKeys.join(',') : '[]',
      'key': '${group.key}',
    });
    return groupJson;
  }
}
