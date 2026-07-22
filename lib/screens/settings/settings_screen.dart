import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: AppPlaceholderView(
        title: 'Settings',
        todo: 'TODO: Add reminders, backup, and app preferences.',
      ),
    );
  }
}
