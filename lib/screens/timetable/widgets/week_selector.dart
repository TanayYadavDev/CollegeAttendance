import 'package:flutter/material.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.hasEvents,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool Function(DateTime date) hasEvents;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final monday = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    return Row(
      children: List.generate(5, (index) {
        final date = monday.add(Duration(days: index));

        final isSelected = DateUtils.isSameDay(
          date,
          selectedDate,
        );

        return SizedBox(
          width: 76,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 76,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEAF5FF).withValues(alpha: 0.20)
                      : const Color(0xFFEAF5FF).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.10),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weekdayName(date.weekday),
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: isSelected ? 0.95 : 0.65,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    return weekdays[weekday - 1];
  }
}