// utils/time_ranges.dart
class TimeRanges {
  static const List<List<String>> horariosRangos = [
    ['07:00-08:20', '08:30-10:00', '10:15-11:45'],
    ['12:00-13:30', '14:00-15:30', '15:45-17:15'],
    ['17:30-19:00', '19:10-20:40', '20:50-22:20'],
  ];

  static List<String> getAllTimeRanges() {
    return horariosRangos.expand((element) => element).toList();
  }
}