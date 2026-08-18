import 'package:flutter/material.dart';

import '../../../../models/timetable_event.dart';

class NextEventCard extends StatelessWidget {
  const NextEventCard({
    super.key,
    required this.event,
    required this.label,
  });

  final TimetableEvent event;
  final String label;

  @override
  Widget build(BuildContext context) {
    final localStart = event.startTime.toLocal();

    final month = _monthName(localStart.month);
    final date = '${localStart.day} $month';

    final time = TimeOfDay.fromDateTime(localStart).format(context);

    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.38),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFFBDE3FF).withValues(alpha: 0.14),
            blurRadius: 22,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.12),
          ),

          const SizedBox(height: 10),

          Text(
            event.subject,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
                const SizedBox(width: 5),
                Text(
                  event.room,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return months[month - 1];
  }
}