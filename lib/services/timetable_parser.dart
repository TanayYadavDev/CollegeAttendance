import '../models/timetable_event.dart';

class TimetableParser {
  static TimetableEvent? parse({
    required String? title,
    required DateTime? startTime,
    required DateTime? endTime,
  }) {
    if (title == null ||
        startTime == null ||
        endTime == null) {
      return null;
    }

    // The event must contain the keyword "Class".
    if (!RegExp(r'\bClass\b', caseSensitive: false).hasMatch(title)) {
      return null;
    }

    final match = RegExp(
      r'\bClass\b\s+(.+)',
      caseSensitive: false,
    ).firstMatch(title);

    if (match == null) {
      return null;
    }

    final classDetails = match.group(1)?.trim();

    if (classDetails == null || classDetails.isEmpty) {
      return null;
    }

    final parts = classDetails.split(RegExp(r'\s+'));

    if (parts.length < 2) {
      return null;
    }

    final room = parts.first;
    final subject = parts.skip(1).join(' ').trim();

    if (subject.isEmpty) {
      return null;
    }

    return TimetableEvent(
      subject: subject,
      room: room,
      startTime: startTime,
      endTime: endTime,
    );
  }
}