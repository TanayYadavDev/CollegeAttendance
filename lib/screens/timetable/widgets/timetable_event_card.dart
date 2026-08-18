import 'package:flutter/material.dart';

import '../../../../models/timetable_event.dart';

class TimetableEventCard extends StatelessWidget {
  const TimetableEventCard({
    super.key,
    required this.event,
  });

  final TimetableEvent event;

  @override
  Widget build(BuildContext context) {
    final start = event.startTime.toLocal();
    final end = event.endTime.toLocal();

    final startTime = TimeOfDay.fromDateTime(start).format(context);
    final endTime = TimeOfDay.fromDateTime(end).format(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.white.withValues(alpha: 0.60),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.room,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.60),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text(
            '$startTime\n$endTime',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}