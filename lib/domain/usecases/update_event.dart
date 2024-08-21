import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/domain/repositories/event_repository.dart';

class UpdateEvent {
  final EventRepository repository;
  UpdateEvent(this.repository);

  Future<void> call(Event event) async {
    return await repository.updateEvent(event);
  }
}
