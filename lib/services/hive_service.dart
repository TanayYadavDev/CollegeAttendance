import 'package:college_attendance/core/constants/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  const HiveService._();

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // TODO: Register Hive adapters before opening typed boxes.

    await Hive.openBox(HiveBoxes.semesters);
    await Hive.openBox(HiveBoxes.subjects);
    await Hive.openBox(HiveBoxes.timetable);
    await Hive.openBox(HiveBoxes.attendance);
  }
}
