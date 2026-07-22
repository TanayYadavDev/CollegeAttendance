class TimetableEntry {
  TimetableEntry({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final String subjectId;
  final int weekday;
  final String startTime;
  final String endTime;

  // TODO: Add Hive adapter/serialization support.
}
