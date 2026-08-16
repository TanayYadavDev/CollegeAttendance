import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;

import '../models/student_profile.dart';

class SamarthService {
  final Dio _dio;

  SamarthService(this._dio);

  static const String _profilePath =
      '/index.php/vidhyarthi/profile/index';

  Future<StudentProfile?> getStudentProfile() async {
    try {
      final response = await _dio.get(
        _profilePath,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final document = html_parser.parse(
        response.data.toString(),
      );

      // ----------------------------------------------------------
      // Student name
      // ----------------------------------------------------------

      final nameElement = document.querySelector(
        '.card strong[style*="font-size"]',
      );

      final name = nameElement?.text.trim() ?? '';

      // ----------------------------------------------------------
      // Programme + registration number
      // ----------------------------------------------------------

      final courseCard = document.querySelector(
        '.dashboard-widget .card',
      );

      final programmeElement = courseCard?.querySelector(
        '.card-header h5',
      );

      final programme =
          programmeElement?.text.trim() ?? '';

      final enrolmentText =
          courseCard?.querySelector('.card-body')?.text ?? '';

      final registrationMatch = RegExp(
        r'Enrolment Number\s*:\s*(\S+)',
        caseSensitive: false,
      ).firstMatch(enrolmentText);

      final registrationNo =
          registrationMatch?.group(1) ?? '';

      // ----------------------------------------------------------
      // Personal details table
      // ----------------------------------------------------------

      String valueForLabel(String label) {
        for (final row in document.querySelectorAll('tr')) {
          final cells = row.querySelectorAll('th, td');

          if (cells.length >= 2 &&
              cells.first.text.trim() == label) {
            return cells[1].text.trim();
          }
        }

        return '';
      }

      final dateOfBirth = valueForLabel('Date of Birth');

      final contactCells = document.querySelectorAll(
        '.col-md-3 table tr td strong',
      );

      String email = '';
      String mobileNumber = '';

      for (final cell in contactCells) {
        final text = cell.text.trim();

        if (text.contains('@')) {
          email = text;
        } else if (RegExp(r'^\d{10}$').hasMatch(text)) {
          mobileNumber = text;
        }
      }

      // ----------------------------------------------------------
      // Profile photo
      // ----------------------------------------------------------

      final photoElement = document.querySelector(
        'img[alt="user-image"]',
      );

      final photoUrl = photoElement?.attributes['src'];

      return StudentProfile(
        name: name,
        registrationNo: registrationNo,
        programme: programme,
        email: email,
        mobileNumber: mobileNumber,
        dateOfBirth: dateOfBirth,
        photoUrl: photoUrl,
      );
    } catch (_) {
      return null;
    }
  }
}