import 'package:flutter/material.dart';
import 'package:calendar_package/calendar_package.dart';

class CalendarDateSelector extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  final List<Map<String, dynamic>> eventDates;

  const CalendarDateSelector({
    super.key,
    required this.onDateSelected,
    required this.eventDates,
  });

  @override
  State<CalendarDateSelector> createState() => _CalendarDateSelectorState();
}

class _CalendarDateSelectorState extends State<CalendarDateSelector> {
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());

  @override
  void dispose() {
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDate,
      builder: (context, selectedDate, child) {
        return CalendarPage(
          date: selectedDate,
          onDateChanged: (newDate) {
            _selectedDate.value = newDate;
            widget.onDateSelected(newDate);
          },
          eventDates: widget.eventDates,
        );
      },
    );
  }
}
