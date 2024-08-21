import 'package:todo_app_udevs/domain/repositories/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteEvent(id);
  }
}
