import 'package:google_sign_in/google_sign_in.dart';

class GoogleCalendarService {
  static const String _serverClientId =
      '756380205026-5prcnrfgelsm9lno8sjgutjot1rruf0i.apps.googleusercontent.com';

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

  Future<GoogleSignInAccount?> signIn() async {
    await initialize();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw StateError(
        'Google Sign-In authentication is not supported on this platform.',
      );
    }

    return _googleSignIn.authenticate();
  }

  Future<void> signOut() async {
    await initialize();
    await _googleSignIn.signOut();
  }
}