import 'package:flutter/material.dart';
import 'package:calendar_package/calendar_package.dart';

class CalendarDateSelector extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  final List<Map<String,dynamic>> eventDates; 

  const CalendarDateSelector({
    super.key,
    required this.onDateSelected,
    required this.eventDates, 
  });

  @override
  State<CalendarDateSelector> createState() => _CalendarDateSelectorState();
}

class _CalendarDateSelectorState extends State<CalendarDateSelector> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CalendarPage(
      date: _selectedDate,
      onDateChanged: (newDate) {
        setState(() {
          _selectedDate = newDate;
        });
        widget.onDateSelected(newDate); 
      },
      eventDates: widget.eventDates, 
    );
  }
}
