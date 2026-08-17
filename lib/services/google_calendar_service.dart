import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

import '../models/timetable_event.dart';
import 'timetable_parser.dart';

class GoogleCalendarService {
  static const String _serverClientId =
      '756380205026-5prcnrfgelsm9lno8sjgutjot1rruf0i.apps.googleusercontent.com';

  static const List<String> _calendarScopes = [
    CalendarApi.calendarReadonlyScope,
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId: _serverClientId,
    );

    _initialized = true;
  }

  Future<GoogleSignInAccount> signIn() async {
    await initialize();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw StateError(
        'Google Sign-In authentication is not supported on this platform.',
      );
    }

    return _googleSignIn.authenticate();
  }

  Future<List<TimetableEvent>> fetchTimetableEvents(
      GoogleSignInAccount account, {
        DateTime? from,
        DateTime? to,
      }) async {
    await initialize();

    // Request Calendar read-only access.
    final authorization = await account.authorizationClient.authorizeScopes(
      _calendarScopes,
    );

    // Convert Google authorization into an authenticated googleapis client.
    final authClient = authorization.authClient(
      scopes: _calendarScopes,
    );

    final calendarApi = CalendarApi(authClient);

    // Find the CSF calendar.
    final calendarList = await calendarApi.calendarList.list(
      maxResults: 100,
    );

    final calendars = calendarList.items ?? [];

    CalendarListEntry? csfCalendar;

    for (final calendar in calendars) {
      if (calendar.summary?.trim().toLowerCase() == 'csf') {
        csfCalendar = calendar;
        break;
      }
    }

    if (csfCalendar == null) {
      throw StateError(
        'CSF calendar was not found in your Google Calendar.',
      );
    }

    final calendarId = csfCalendar.id;

    if (calendarId == null) {
      throw StateError(
        'CSF calendar does not have a valid calendar ID.',
      );
    }

    if (calendarId == null) {
      throw StateError(
        'CSF calendar does not have a valid calendar ID.',
      );
    }

    final now = DateTime.now();

    final start = from ?? DateTime(
      now.year,
      now.month,
      now.day,
    );

    final end = to ?? start.add(
      const Duration(days: 7),
    );

    final eventsResponse = await calendarApi.events.list(
      calendarId,
      timeMin: start,
      timeMax: end,
      singleEvents: true,
      orderBy: 'startTime',
      maxResults: 250,
    );

    final timetableEvents = <TimetableEvent>[];

    for (final event in eventsResponse.items ?? []) {
      final startTime = event.start?.dateTime;
      final endTime = event.end?.dateTime;

      final parsedEvent = TimetableParser.parse(
        title: event.summary,
        startTime: startTime.toLocal(),
        endTime: endTime.toLocal(),
      );

      if (parsedEvent != null) {
        timetableEvents.add(parsedEvent);
      }
    }

    return timetableEvents;
  }

  Future<void> signOut() async {
    await initialize();
    await _googleSignIn.signOut();
  }
}