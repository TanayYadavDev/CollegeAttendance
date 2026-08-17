import 'package:flutter/material.dart';

import 'google_connect_button.dart';

class CalendarConnectView extends StatelessWidget {
  const CalendarConnectView({
    super.key,
    required this.onConnect,
    this.error,
  });

  final Future<void> Function() onConnect;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 48,
                color: Color(0xFF023E8A),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Connect your calendar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Connect your Google Calendar to import '
                  'your college timetable automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: GoogleConnectButton(
                onPressed: onConnect,
              ),
            ),

            if (error != null) ...[
              const SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}