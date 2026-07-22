import 'package:college_attendance/core/constants/route_constants.dart';
import 'package:college_attendance/screens/attendance/attendance_screen.dart';
import 'package:college_attendance/screens/dashboard/dashboard_screen.dart';
import 'package:college_attendance/screens/semester/semester_screen.dart';
import 'package:college_attendance/screens/settings/settings_screen.dart';
import 'package:college_attendance/screens/subject/subject_screen.dart';
import 'package:college_attendance/screens/timetable/timetable_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.dashboard,
    routes: [
      GoRoute(
        path: RouteConstants.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteConstants.timetable,
        builder: (context, state) => const TimetableScreen(),
      ),
      GoRoute(
        path: RouteConstants.attendance,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: RouteConstants.semester,
        builder: (context, state) => const SemesterScreen(),
      ),
      GoRoute(
        path: RouteConstants.subject,
        builder: (context, state) => const SubjectScreen(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
