import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/domain/repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository repository;

  GetAllEvents(this.repository);

  Future<List<Event>> call() async {
    final events = await repository.getAllEvents();
    return events;
  }
}
