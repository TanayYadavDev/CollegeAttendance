import 'package:flutter/material.dart';

import 'timetable_content_view.dart';
import '../widgets/calendar_connect_view.dart';
import '../../../models/timetable_event.dart';
import '../../../services/google_calendar_service.dart';

class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final GoogleCalendarService _googleCalendarService =
  GoogleCalendarService();

  List<TimetableEvent> _events = [];

  bool _isConnected = false;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 61, 138),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_isConnected) {
      return TimetableContentView(
        events: _events,
        onRefresh: _refreshTimetable,
      );
    }

    return CalendarConnectView(
      onConnect: _connectGoogleCalendar,
      error: _error,
    );  }

  // ---------------------------------------------------------------------------
  // GOOGLE LOGIN + CALENDAR FETCH
  // ---------------------------------------------------------------------------

  Future<void> _connectGoogleCalendar() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final account = await _googleCalendarService.signIn();

      final events = await _googleCalendarService.fetchTimetableEvents(
        account,
      );

      for (final event in events) {
        debugPrint(
          'TIMETABLE: '
              '${event.subject} | '
              '${event.room} | '
              '${event.startTime} → '
              '${event.endTime}',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _events = events;
        _isConnected = true;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _error = 'Calendar error: $error';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // REFRESH TIMETABLE ON EVERY PULL
  // ---------------------------------------------------------------------------

  Future<void> _refreshTimetable() async {
    debugPrint('REFRESH: triggered');

    try {
      final events =
      await _googleCalendarService.refreshTimetableEvents();

      debugPrint('REFRESH: fetched ${events.length} events');

      if (!mounted) {
        return;
      }

      setState(() {
        _events = events;
      });
    } catch (error) {
      debugPrint('REFRESH: ERROR $error');

      if (!mounted) {
        return;
      }

      setState(() {
        _error = 'Refresh failed: $error';
      });
    }
  }
}