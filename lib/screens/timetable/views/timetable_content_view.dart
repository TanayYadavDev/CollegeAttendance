import 'package:flutter/material.dart';

import '../widgets/timetable_event_card.dart';
import '../../../models/timetable_event.dart';
import '../widgets/next_event_card.dart';
import '../widgets/week_selector.dart';

class TimetableContentView extends StatefulWidget {
  const TimetableContentView({
    super.key,
    required this.events,
  });

  final List<TimetableEvent> events;

  @override
  State<TimetableContentView> createState() =>
      _TimetableContentViewState();
}

class _TimetableContentViewState extends State<TimetableContentView> {
  DateTime _selectedDate = DateTime.now();

  TimetableEvent? get _nextEvent {
    final now = DateTime.now();

    final upcomingEvents = widget.events.where((event) {
      return event.endTime.toLocal().isAfter(now);
    }).toList();

    if (upcomingEvents.isEmpty) {
      return null;
    }

    upcomingEvents.sort(
          (a, b) => a.startTime.compareTo(b.startTime),
    );

    return upcomingEvents.first;
  }

  @override
  Widget build(BuildContext context) {
    final nextEvent = _nextEvent;
    return Column(
      children: [
        // ---------------------------------------------------------------
        // STATIC NEXT EVENT
        // ---------------------------------------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: nextEvent != null
              ? NextEventCard(
            event: nextEvent,
          )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: 15),

        // ---------------------------------------------------------------
        // WEEK + EVENTS CONTAINER
        // ---------------------------------------------------------------

        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------
                // HORIZONTAL DAY SCROLL
                // -------------------------------------------------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: WeekSelector(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    hasEvents: _hasEventsOnDate,
                  ),
                ),

                const SizedBox(height: 15),

                // -------------------------------------------------------
                // EVENTS CONTAINER
                // -------------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: _buildSelectedDayEvents(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  bool _hasEventsOnDate(DateTime date) {
    return widget.events.any(
          (event) => DateUtils.isSameDay(
        event.startTime.toLocal(),
        date,
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    final selectedEvents = widget.events.where(
          (event) => DateUtils.isSameDay(
        event.startTime.toLocal(),
        _selectedDate,
      ),
    ).toList();

    selectedEvents.sort(
          (a, b) => a.startTime.compareTo(b.startTime),
    );

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No classes scheduled',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            fontSize: 15,
          ),
        ),
      );
    }

    // ---------------------------------------------------------------
    // VERTICAL EVENT SCROLL
    // ---------------------------------------------------------------

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: selectedEvents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        return TimetableEventCard(
          event: event,
        );
      },
    );
  }
}