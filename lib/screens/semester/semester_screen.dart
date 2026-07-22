import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Semester')),
      body: AppPlaceholderView(
        title: 'Semester',
        todo: 'TODO: Add semester CRUD and active semester selection.',
      ),
    );
  }
}
