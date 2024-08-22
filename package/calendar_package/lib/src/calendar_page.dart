import 'package:calendar_package/src/utils/calender_utils.dart';
import 'package:calendar_package/src/widgets/calendar_grid.dart';
import 'package:calendar_package/src/widgets/month_selector.dart';
import 'package:flutter/material.dart';
import 'widgets/week_day_label.dart';

class CalendarPage extends StatefulWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onDateChanged;
  final List<Map<String, dynamic>> eventDates;

  const CalendarPage({
    Key? key,
    required this.date,
    required this.onDateChanged,
    required this.eventDates,
  }) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final PageController _pageController;
  late final ValueNotifier<DateTime> _selectedDate;
  late final int initialPageIndex;
  late DateTime _currentMonth;
  late List<DateTime> _filteredDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime>(widget.date ?? DateTime.now());
    initialPageIndex = CalendarUtils.getInitialPageIndex();
    _pageController = PageController(initialPage: initialPageIndex);
    _currentMonth = CalendarUtils.getMonthStart(_selectedDate.value);
    _filteredDates =
        CalendarUtils.filterEvents(widget.eventDates, _currentMonth);

    _selectedDate.addListener(() {
      widget.onDateChanged(_selectedDate.value);
      setState(() {
        _currentMonth = CalendarUtils.getMonthStart(_selectedDate.value);
        _filteredDates =
            CalendarUtils.filterEvents(widget.eventDates, _currentMonth);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedDate.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    final newMonth = CalendarUtils.getMonthFromPageIndex(page);
    _selectedDate.value = CalendarUtils.getMonthStart(newMonth);
  }

  void _onMonthChanged(int increment) {
    final newPageIndex = _pageController.page!.round() + increment;
    _pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonthSelector(
              selectedDate: _selectedDate,
              onMonthChanged: _onMonthChanged,
            ),
            const SizedBox(height: 16.0),
            const WeekdayLabels(),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: CalendarUtils.totalPageCount,
                itemBuilder: (context, index) {
                  final year = 1950 + index ~/ 12;
                  final month = index % 12 + 1;
                  return CalendarGrid(
                    month: DateTime(year, month),
                    selectedDate: _selectedDate,
                    eventDates: _filteredDates,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
