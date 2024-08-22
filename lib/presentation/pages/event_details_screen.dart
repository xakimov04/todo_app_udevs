import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_app_udevs/presentation/pages/add_event_screen.dart';
import 'package:todo_app_udevs/presentation/widgets/event_details_widgets/delete_button.dart';
import 'package:todo_app_udevs/presentation/widgets/event_details_widgets/event_content.dart';
import 'package:todo_app_udevs/presentation/widgets/event_details_widgets/event_header.dart';
import '../../domain/entities/event.dart';
import '../widgets/event_details_widgets/animated_dialog.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _formatRemainingTime(_remainingTime());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          DeleteButton(onPressed: () => _onDeleteEvent(context)),
      body: CustomScrollView(
        slivers: [
          EventHeader(event: _event, onEdit: _onEditEvent),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: EventContent(event: _event, remainingTime: remainingTime),
          ),
        ],
      ),
    );
  }

  Duration _remainingTime() {
    final endTimeString = _event.endTime;
    final endTime = DateTime.parse(endTimeString);
    return endTime.difference(DateTime.now());
  }

  String _formatRemainingTime(Duration duration) {
    if (duration.isNegative) {
      return 'Event has ended';
    } else {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      return '$days days, $hours hours, $minutes minutes';
    }
  }

  void _onDeleteEvent(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedDialog(id: _event.id!);
      },
    );
  }

  Future<void> _onEditEvent() async {
    final updatedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          event: _event,
          dateTime: _event.dateTime,
        ),
      ),
    ) as Event?;

    if (updatedEvent != null) {
      setState(() {
        _event = updatedEvent;
      });
    }
  }
}
