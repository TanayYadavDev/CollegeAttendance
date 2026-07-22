import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Subject')),
      body: AppPlaceholderView(
        title: 'Subject',
        todo: 'TODO: Add subject CRUD and attendance target setup.',
      ),
    );
  }
}
