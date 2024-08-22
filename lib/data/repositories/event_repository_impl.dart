import 'package:todo_app_udevs/data/datasources/event_local_datasource.dart';
import 'package:todo_app_udevs/data/models/event_model.dart';
import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource localDataSource;

  EventRepositoryImpl(this.localDataSource);

  @override
  Future<void> addEvent(Event event) async {
    final eventModel = EventModel(
      name: event.name,
      description: event.description,
      location: event.location,
      time: event.time,
      color: event.color,
      dateTime: event.dateTime,
      endTime: event.endTime,
    );
    return await localDataSource.insertEvent(eventModel);
  }

  @override
  Future<List<Event>> getAllEvents() async {
    return await localDataSource.getEvents();
  }

  @override
  Future<void> deleteEvent(int id) async {
    return await localDataSource.deleteEvent(id);
  }

  @override
  Future<void> updateEvent(Event event) async {
    final eventModel = EventModel(
      id: event.id,
      name: event.name,
      description: event.description,
      location: event.location,
      time: event.time,
      color: event.color,
      dateTime: event.dateTime,
      endTime: event.endTime,
    );
    return await localDataSource.updateEvent(eventModel);
  }
}
