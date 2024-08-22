
import 'package:calendar_package/src/widgets/day_widgets.dart';
import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime month;
  final ValueNotifier<DateTime> selectedDate;
  final List<DateTime> eventDates;

  const CalendarGrid({
    Key? key,
    required this.month,
    required this.selectedDate,
    required this.eventDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    List<Widget> dayWidgets =
        List.generate(startWeekday, (_) => const SizedBox.shrink())
          ..addAll(List.generate(
              daysInMonth,
              (day) => DayWidget(
                    day: day + 1,
                    isSelected: selectedDate.value.day == day + 1,
                    eventDates: eventDates,
                    onTap: () {
                      selectedDate.value =
                          DateTime(month.year, month.month, day + 1);
                    },
                  )));

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }
}