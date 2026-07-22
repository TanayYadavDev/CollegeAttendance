import 'package:college_attendance/core/constants/route_constants.dart';
import 'package:college_attendance/widgets/app_placeholder_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          const Expanded(
            child: AppPlaceholderView(
              title: 'Dashboard',
              todo: 'TODO: Add attendance summary cards and quick stats.',
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () => context.go(RouteConstants.semester),
                child: const Text('Semester'),
              ),
              FilledButton(
                onPressed: () => context.go(RouteConstants.subject),
                child: const Text('Subject'),
              ),
              FilledButton(
                onPressed: () => context.go(RouteConstants.timetable),
                child: const Text('Timetable'),
              ),
              FilledButton(
                onPressed: () => context.go(RouteConstants.attendance),
                child: const Text('Attendance'),
              ),
              FilledButton(
                onPressed: () => context.go(RouteConstants.settings),
                child: const Text('Settings'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
