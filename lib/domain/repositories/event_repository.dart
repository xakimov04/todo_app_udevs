import 'package:todo_app_udevs/domain/entities/event.dart';

abstract class EventRepository {
  Future<void> addEvent(Event event);
  Future<List<Event>> getAllEvents();
  Future<void> deleteEvent(int id);
  Future<void> updateEvent(Event event);
}
