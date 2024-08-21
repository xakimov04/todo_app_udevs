import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_udevs/injection.dart'; 
import 'package:todo_app_udevs/presentation/pages/calendar_screen.dart';
import 'presentation/blocs/event_bloc/event_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<EventBloc>(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  CalendarScreen(),
      ),
    );
  }
}
