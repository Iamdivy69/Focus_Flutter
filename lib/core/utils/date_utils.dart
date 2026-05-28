/// Date/time utility helpers used across FocusShield.
class FsDateUtils {
  FsDateUtils._();

  /// Returns midnight (00:00:00) of the given [date].
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Returns 23:59:59.999 of the given [date].
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  /// Returns midnight of today.
  static DateTime get todayStart => startOfDay(DateTime.now());

  /// Returns midnight of yesterday.
  static DateTime get yesterdayStart =>
      startOfDay(DateTime.now().subtract(const Duration(days: 1)));

  /// Returns true if [date] falls within the night window (22:00–06:00).
  static bool isNightHour(DateTime date) {
    final hour = date.hour;
    return hour >= 22 || hour < 6;
  }

  /// Returns true if [date] falls within the morning window (06:00–10:00).
  static bool isMorningHour(DateTime date) {
    final hour = date.hour;
    return hour >= 6 && hour < 10;
  }

  /// Formats [minutes] as "Xh Ym" (e.g. "1h 30m") or "Ym" if < 60.
  static String formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  /// Formats [seconds] as "HH:MM:SS".
  static String formatSeconds(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  /// Returns the ISO week number for [date].
  static int weekNumber(DateTime date) {
    final dayOfYear = int.parse(
      date.difference(DateTime(date.year, 1, 1)).inDays.toString(),
    );
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// Returns a list of the last [days] dates (inclusive of today), newest first.
  static List<DateTime> lastNDays(int days) {
    final today = todayStart;
    return List.generate(days, (i) => today.subtract(Duration(days: i)));
  }
}
