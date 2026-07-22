import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: AppPlaceholderView(
        title: 'Attendance',
        todo: 'TODO: Add mark attendance flow and monthly analytics.',
      ),
    );
  }
}
