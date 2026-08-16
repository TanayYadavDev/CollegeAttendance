import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/parser.dart' as html_parser;

class AuthService {
  static const String _baseUrl = 'https://mnnit.samarth.edu.in';
  static const String _loginPath = '/index.php/site/login';
  static const String _dashboardPath = '/index.php/dashboard';

  late final Dio _dio;
  late final CookieJar _cookieJar;

  Dio get client => _dio;

  bool _isLoggedIn = false;

  AuthService() {
    _cookieJar = CookieJar();

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'User-Agent':
          'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/150.0 Mobile Safari/537.36',
        },
      ),
    );

    _dio.interceptors.add(
      CookieManager(_cookieJar),
    );
  }

  Future<bool> isLoggedIn() async {
    if (!_isLoggedIn) {
      return false;
    }

    try {
      final response = await _dio.get(
        _dashboardPath,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      final location = response.headers.value('location');

      if (response.statusCode == 302 &&
          location != null &&
          location.contains('/site/login')) {
        _isLoggedIn = false;
        return false;
      }

      return response.statusCode == 200;
    } catch (_) {
      _isLoggedIn = false;
      return false;
    }
  }

  Future<bool> login({
    required String registrationNo,
    required String password,
  }) async {
    try {
      // ------------------------------------------------------------
      // STEP 1: Open Samarth login page
      // ------------------------------------------------------------

      final loginPageResponse = await _dio.get(
        _loginPath,
        options: Options(
          followRedirects: true,
        ),
      );

      if (loginPageResponse.statusCode != 200) {
        return false;
      }

      final html = loginPageResponse.data.toString();

      // ------------------------------------------------------------
      // STEP 2: Extract dynamic CSRF token
      // ------------------------------------------------------------

      final document = html_parser.parse(html);

      final csrfInput = document.querySelector(
        'input[name="_csrf"]',
      );

      final csrfToken = csrfInput?.attributes['value'];

      if (csrfToken == null || csrfToken.isEmpty) {
        return false;
      }

      // ------------------------------------------------------------
      // STEP 3: Submit credentials
      // ------------------------------------------------------------

      final loginResponse = await _dio.post(
        _loginPath,
        data: {
          '_csrf': csrfToken,
          'LoginForm[username]': registrationNo.trim(),
          'LoginForm[password]': password,
          'login-button': '',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      // ------------------------------------------------------------
      // STEP 4: Check redirect
      // ------------------------------------------------------------

      final location = loginResponse.headers.value('location');

      final redirectedToDashboard =
          loginResponse.statusCode != null &&
              loginResponse.statusCode! >= 300 &&
              loginResponse.statusCode! < 400 &&
              location != null &&
              location.contains('/dashboard');

      if (!redirectedToDashboard) {
        _isLoggedIn = false;
        return false;
      }

      // ------------------------------------------------------------
      // STEP 5: Verify authenticated session
      // ------------------------------------------------------------

      final dashboardResponse = await _dio.get(
        _dashboardPath,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      final dashboardLocation =
      dashboardResponse.headers.value('location');

      final redirectedBackToLogin =
          dashboardResponse.statusCode != null &&
              dashboardResponse.statusCode! >= 300 &&
              dashboardResponse.statusCode! < 400 &&
              dashboardLocation != null &&
              dashboardLocation.contains('/site/login');

      if (redirectedBackToLogin) {
        _isLoggedIn = false;
        return false;
      }

      if (dashboardResponse.statusCode == 200) {
        _isLoggedIn = true;
        return true;
      }

      _isLoggedIn = false;
      return false;
    } catch (_) {
      _isLoggedIn = false;
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _cookieJar.deleteAll();
  }
}