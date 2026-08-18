import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/timetable_event_card.dart';
import '../../../models/timetable_event.dart';
import '../widgets/next_event_card.dart';
import '../widgets/week_selector.dart';


class TimetableContentView extends StatefulWidget {
  const TimetableContentView({
    super.key,
    required this.events,
    required this.onRefresh,
  });

  final Future<void> Function() onRefresh;
  final List<TimetableEvent> events;

  @override
  State<TimetableContentView> createState() =>
      _TimetableContentViewState();
}

class _TimetableContentViewState extends State<TimetableContentView> {
  DateTime _selectedDate = DateTime.now();

  Timer? _timeRefreshTimer;

  @override
  void initState() {
    super.initState();

    print('TIMER: initState()');
    print('TIMER: initial events = ${widget.events.length}');

    _scheduleTimeRefresh();
  }

  void _scheduleTimeRefresh() {
    print('TIMER: _scheduleTimeRefresh() called');

    _timeRefreshTimer?.cancel();
    print('TIMER: previous timer cancelled');

    final now = DateTime.now();
    print('TIMER: now = $now');
    print('TIMER: events count = ${widget.events.length}');

    DateTime? nextRefresh;

    for (final event in widget.events) {
      final startTime = event.startTime.toLocal();
      final endTime = event.endTime.toLocal();

      final transitionTime = endTime.subtract(
        const Duration(minutes: 25),
      );

      print(
        'TIMER: ${event.subject} | '
            'start=$startTime | '
            'end=$endTime | '
            'transition=$transitionTime',
      );

      if (transitionTime.isAfter(now)) {
        print(
          'TIMER: ${event.subject} transition is in the future',
        );

        if (nextRefresh == null ||
            transitionTime.isBefore(nextRefresh)) {
          nextRefresh = transitionTime;

          print(
            'TIMER: NEW NEXT REFRESH = $nextRefresh '
                '(${event.subject})',
          );
        }
      } else {
        print(
          'TIMER: ${event.subject} transition already passed',
        );
      }
    }

    if (nextRefresh == null) {
      print('TIMER: NO FUTURE TRANSITION FOUND');
      return;
    }

    final duration = nextRefresh.difference(now);

    print(
      'TIMER: scheduling timer for $duration '
          '(at $nextRefresh)',
    );

    _timeRefreshTimer = Timer(
      duration,
          () {
        print('TIMER: 🔥 TIMER FIRED at ${DateTime.now()}');

        if (!mounted) {
          print('TIMER: widget is NOT mounted, stopping');
          return;
        }

        print('TIMER: calling setState()');

        setState(() {});

        print('TIMER: setState completed');

        _scheduleTimeRefresh();
      },
    );

    print('TIMER: timer created successfully');
  }

  @override
  void didUpdateWidget(covariant TimetableContentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
      'TIMER: didUpdateWidget | '
          'old events=${oldWidget.events.length} | '
          'new events=${widget.events.length}',
    );
    if (oldWidget.events != widget.events) {
      print(
        'TIMER: _scheduleTimeRefresh() | '
            'events=${widget.events.length}',
      );
      _scheduleTimeRefresh();
    }
  }

  @override
  void dispose() {
    print('TIMER: dispose()');
    _timeRefreshTimer?.cancel();
    print('TIMER: timer cancelled');
    super.dispose();
  }

  TimetableEvent? get _nowEvent {
    final now = DateTime.now();

    for (final event in widget.events) {
      final start = event.startTime.toLocal();
      final end = event.endTime.toLocal();

      final nowUntilEnd = end.difference(now);
      final isOngoing = now.isAfter(start) && now.isBefore(end);

      if (isOngoing && nowUntilEnd > const Duration(minutes: 25)) {
        return event;
      }
    }
    return null;
  }

  TimetableEvent? get _nextEvent {
    final now = DateTime.now();

    final upcomingEvents = widget.events.where((event) {
      final start = event.startTime.toLocal();
      return start.isAfter(now);
    }).toList();

    upcomingEvents.sort((a, b) => a.startTime.compareTo(b.startTime),);
    return upcomingEvents.isEmpty ? null : upcomingEvents.first;
  }

  @override
  Widget build(BuildContext context) {
    final nowEvent = _nowEvent;
    final nextEvent = _nextEvent;
    final displayEvent = nowEvent ?? nextEvent;

    print(
      'UI: rebuild | '
          'time=${DateTime.now()} | '
          'NOW=${nowEvent?.subject} | '
          'NEXT=${nextEvent?.subject}',
    );

    return Column(
      children: [

        // ---------------------------------------------------------------
        // STATIC NEXT EVENT
        // ---------------------------------------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: displayEvent != null
              ? NextEventCard(
            event: displayEvent,
            label: nowEvent != null ? 'NOW' : 'NEXT',
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

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: const Color(0xFF023E8A),
      backgroundColor: const Color(0xFFEAF5FF),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: selectedEvents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return TimetableEventCard(
            event: selectedEvents[index],
          );
        },
      ),
    );
  }
}