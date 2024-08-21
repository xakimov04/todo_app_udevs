import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_udevs/presentation/blocs/event_bloc/event_bloc.dart';
import 'package:todo_app_udevs/presentation/pages/add_event_screen.dart';
import 'package:todo_app_udevs/presentation/widgets/calendar_widgets/app_bar.dart';
import 'package:todo_app_udevs/presentation/widgets/calendar_widgets/calendar_date_selector.dart';
import 'package:todo_app_udevs/presentation/widgets/calendar_widgets/event_list.dart';

import '../../core/utils/constants.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> eventDates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        dateTime: _selectedDate,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventsLoaded) {
                  eventDates = state.events.map((event) {
                    return {
                      'dateTime': event.dateTime,
                      'color': event.color,
                    };
                  }).toList();
                }
                return CalendarDateSelector(
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                    context
                        .read<EventBloc>()
                        .add(LoadEvents(date: _selectedDate));
                  },
                  eventDates: eventDates,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Schedule",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.primaryColor,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEventScreen(
                              dateTime: _selectedDate,
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "+ Add Event",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<EventBloc, EventState>(
            bloc: context.read<EventBloc>()
              ..add(LoadEvents(date: _selectedDate)),
            builder: (context, state) {
              if (state is EventLoading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is EventsLoaded) {
                if (state.events.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Lottie.asset("assets/lottie/not.json"),
                    ),
                  );
                }
                return EventList(events: state.events);
              } else if (state is EventError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<EventBloc>()
                                .add(LoadEvents(date: _selectedDate));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No events found.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
