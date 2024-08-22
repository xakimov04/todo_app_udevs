
class CalendarUtils {
  static int getInitialPageIndex() {
    final now = DateTime.now();
    return (now.year - 1950) * 12 + now.month - 1;
  }

  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static DateTime getMonthFromPageIndex(int pageIndex) {
    return DateTime(1950 + pageIndex ~/ 12, pageIndex % 12 + 1);
  }

  static List<DateTime> filterEvents(
      List<Map<String, dynamic>> events, DateTime month) {
    return events
        .where((event) {
          final eventDate = event['dateTime'] as DateTime;
          return eventDate.year == month.year && eventDate.month == month.month;
        })
        .map((e) => e['dateTime'] as DateTime)
        .toList();
  }

  static int get totalPageCount => (2950 - 1950) * 12;
}
