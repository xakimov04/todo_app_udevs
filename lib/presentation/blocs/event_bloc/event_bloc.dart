import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/domain/usecases/add_event.dart';
import 'package:todo_app_udevs/domain/usecases/delete_event.dart';
import 'package:todo_app_udevs/domain/usecases/get_all_events.dart';
import 'package:todo_app_udevs/domain/usecases/update_event.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final AddEvent _addEventUseCase;
  final GetAllEvents _getAllEventsUseCase;
  final UpdateEvent _updateEventUseCase;
  final DeleteEvent _deleteEventUseCase;

  EventBloc({
    required AddEvent addEventUseCase,
    required GetAllEvents getAllEventsUseCase,
    required UpdateEvent updateEventUseCase,
    required DeleteEvent deleteEventUseCase,
  })  : _addEventUseCase = addEventUseCase,
        _getAllEventsUseCase = getAllEventsUseCase,
        _updateEventUseCase = updateEventUseCase,
        _deleteEventUseCase = deleteEventUseCase,
        super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddNewEvent>(_onAddNewEvent);
    on<UpdateExistingEvent>(_onUpdateExistingEvent);
    on<DeleteExistingEvent>(_onDeleteExistingEvent);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await _getAllEventsUseCase();
      if (event.date != null) {
        final selectedDate = event.date!;
        final filteredEvents = events.where((e) {
          final eventDate =
              DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
          return eventDate ==
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        }).toList();
        emit(EventsLoaded(events: filteredEvents));
      } else {
        emit(EventsLoaded(events: events));
      }
    } catch (e) {
      print(e);
      // emit(const EventError(message: ));
    }
  }

  Future<void> _onAddNewEvent(
      AddNewEvent event, Emitter<EventState> emit) async {
    try {
      await _addEventUseCase(event.event);
      add(const LoadEvents());
    } catch (_) {
      emit(const EventError(message: 'Failed to add event.'));
    }
  }

  Future<void> _onUpdateExistingEvent(
      UpdateExistingEvent event, Emitter<EventState> emit) async {
    try {
      await _updateEventUseCase(event.event);
      add(const LoadEvents());
    } catch (_) {
      emit(const EventError(message: 'Failed to update event.'));
    }
  }

  Future<void> _onDeleteExistingEvent(
      DeleteExistingEvent event, Emitter<EventState> emit) async {
    try {
      await _deleteEventUseCase(event.eventId);
      add(const LoadEvents());
    } catch (_) {
      emit(const EventError(message: 'Failed to delete event.'));
    }
  }
}
