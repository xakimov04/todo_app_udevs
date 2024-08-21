import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/domain/repositories/event_repository.dart';

class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<void> call(Event event) async {
    return await repository.addEvent(event);
  }
}
