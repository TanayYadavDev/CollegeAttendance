import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Timetable')),
      body: AppPlaceholderView(
        title: 'Timetable',
        todo: 'TODO: Add weekly schedule management and class slots.',
      ),
    );
  }
}
