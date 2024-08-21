import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime>(widget.date ?? DateTime.now());
    initialPageIndex = _getInitialPageIndex();
    _pageController = PageController(initialPage: initialPageIndex);
    _selectedDate.addListener(() {
      widget.onDateChanged(_selectedDate.value);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedDate.dispose();
    super.dispose();
  }

  int _getInitialPageIndex() {
    final now = DateTime.now();
    return (now.year - 1950) * 12 + now.month - 1;
  }

  void _onPageChanged(int page) {
    final newMonth = DateTime(1950 + page ~/ 12, page % 12 + 1);
    _selectedDate.value = DateTime(newMonth.year, newMonth.month, 1);
  }

  void _onMonthChanged(int increment) {
    final newPageIndex = _pageController.page!.round() + increment;
    _pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDayWidget(int day, bool isSelected) {
    final dayEvents = widget.eventDates.where((event) {
      final eventDate = event['dateTime'];
      return eventDate.year == _selectedDate.value.year &&
          eventDate.month == _selectedDate.value.month &&
          eventDate.day == day;
    }).toList();

    return GestureDetector(
      onTap: () => _selectedDate.value = DateTime(
        _selectedDate.value.year,
        _selectedDate.value.month,
        day,
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (dayEvents.isNotEmpty)
                  Positioned(
                    bottom: -10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayEvents.map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Color(event['color']),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    List<Widget> dayWidgets = List.generate(
        startWeekday, (_) => const SizedBox.shrink())
      ..addAll(List.generate(
          daysInMonth,
          (day) =>
              _buildDayWidget(day + 1, _selectedDate.value.day == day + 1)));

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff969696),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthSelector() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDate,
      builder: (context, selectedDate, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM').format(selectedDate),
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xffEFEFEF),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                    onPressed: () => _onMonthChanged(-1),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: const Color(0xffEFEFEF),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: () => _onMonthChanged(1),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSelector(),
          const SizedBox(height: 16.0),
          _buildWeekdayLabels(),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: (2950 - 1950) * 12,
              itemBuilder: (context, index) {
                final year = 1950 + index ~/ 12;
                final month = index % 12 + 1;
                return _buildCalendar(DateTime(year, month));
              },
            ),
          ),
        ],
      ),
    );
  }
}
