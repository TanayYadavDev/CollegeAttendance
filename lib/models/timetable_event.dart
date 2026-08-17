class TimetableEvent {
  final String subject;
  final String room;
  final DateTime startTime;
  final DateTime endTime;

  const TimetableEvent({
    required this.subject,
    required this.room,
    required this.startTime,
    required this.endTime,
  });
}