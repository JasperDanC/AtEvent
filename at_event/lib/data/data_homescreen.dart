import 'package:at_event/models/events_model_homescreen.dart';
import 'package:at_event/models/event_type_model_homescreen.dart';

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = [];
  EventTypeModel eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/party.png";
  eventModel.eventType = "Concert";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //2
  eventModel.imgAssetPath = "assets/concert.png";
  eventModel.eventType = "Sports";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //3
  eventModel.imgAssetPath = "assets/bar.png";
  eventModel.eventType = "Bar";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  return events;
}

List<EventsModel> getEvents() {
  List<EventsModel> events = [];
  EventsModel eventsModel = new EventsModel();

  //1
  eventsModel.imgeAssetPath = "assets/tileimg.png";
  eventsModel.date = "Oct 05, 2021";
  eventsModel.desc = "Party at Fred's Place";
  eventsModel.address = "123 Avenue South Place";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //2
  eventsModel.imgeAssetPath = "assets/";
  eventsModel.date = "Nov 20, 2021";
  eventsModel.desc = "Rec Soccer Game with Friends";
  eventsModel.address = "6468 8th Street East";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //3
  eventsModel.imgeAssetPath = "assets/";
  eventsModel.date = "December 24, 2021";
  eventsModel.address = "2020 Education Street";
  eventsModel.desc = "Youth Concert at Faithful Church";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  return events;
}
