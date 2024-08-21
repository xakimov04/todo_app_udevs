part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {
  final DateTime? date;

  const LoadEvents({this.date});

  @override
  List<Object?> get props => [date];
}

class AddNewEvent extends EventEvent {
  final Event event;

  const AddNewEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateExistingEvent extends EventEvent {
  final Event event;

  const UpdateExistingEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteExistingEvent extends EventEvent {
  final int eventId;

  const DeleteExistingEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
