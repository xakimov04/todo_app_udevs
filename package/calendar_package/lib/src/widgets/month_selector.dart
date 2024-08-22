import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final void Function(int) onMonthChanged;

  const MonthSelector({
    Key? key,
    required this.selectedDate,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDate,
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
                    onPressed: () => onMonthChanged(-1),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: const Color(0xffEFEFEF),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: () => onMonthChanged(1),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
