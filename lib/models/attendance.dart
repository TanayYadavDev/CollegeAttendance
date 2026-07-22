class AttendanceRecord {
  AttendanceRecord({
    required this.id,
    required this.subjectId,
    required this.totalClasses,
    required this.attendedClasses,
  });

  final String id;
  final String subjectId;
  final int totalClasses;
  final int attendedClasses;

  // TODO: Add Hive adapter/serialization support.
}
