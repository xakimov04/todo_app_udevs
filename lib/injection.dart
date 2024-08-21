import 'package:get_it/get_it.dart';
import 'package:todo_app_udevs/data/datasources/event_local_datasource.dart';
import 'package:todo_app_udevs/data/datasources/event_local_datasource_impl.dart';
import 'package:todo_app_udevs/data/repositories/event_repository_impl.dart';
import 'package:todo_app_udevs/domain/repositories/event_repository.dart';
import 'package:todo_app_udevs/domain/usecases/add_event.dart';
import 'package:todo_app_udevs/domain/usecases/delete_event.dart';
import 'package:todo_app_udevs/domain/usecases/get_all_events.dart';
import 'package:todo_app_udevs/domain/usecases/update_event.dart';
import 'presentation/blocs/event_bloc/event_bloc.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  getIt.registerSingleton<EventLocalDataSource>(EventLocalDataSourceImpl());

  getIt.registerSingleton<EventRepository>(
    EventRepositoryImpl(getIt.get<EventLocalDataSource>()),
  );

  getIt.registerSingleton<AddEvent>(
    AddEvent(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<GetAllEvents>(
    GetAllEvents(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<DeleteEvent>(
    DeleteEvent(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<UpdateEvent>(
    UpdateEvent(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<EventBloc>(
    EventBloc(
        addEventUseCase: getIt.get<AddEvent>(),
        getAllEventsUseCase: getIt.get<GetAllEvents>(),
        deleteEventUseCase: getIt.get<DeleteEvent>(),
        updateEventUseCase: getIt.get<UpdateEvent>()),
  );
}
