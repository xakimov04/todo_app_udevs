
import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  final int day;
  final bool isSelected;
  final List<DateTime> eventDates;
  final VoidCallback onTap;

  const DayWidget({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.eventDates,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayEvents =
        eventDates.where((eventDate) => eventDate.day == day).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (dayEvents.isNotEmpty)
                  Positioned(
                    bottom: -10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayEvents.map((eventDate) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
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
}