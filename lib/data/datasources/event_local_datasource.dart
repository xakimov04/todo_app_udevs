import 'package:todo_app_udevs/data/models/event_model.dart';

abstract class EventLocalDataSource {
  Future<void> insertEvent(EventModel event);
  Future<List<EventModel>> getEvents();
  Future<void> deleteEvent(int id);
  Future<void> updateEvent(EventModel event);
}
