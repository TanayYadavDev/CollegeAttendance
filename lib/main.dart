import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CollegeAttendanceApp());
}

class CollegeAttendanceApp extends StatelessWidget {
  const CollegeAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFCAF0F8),
        body: SizedBox.expand(),
      ),
    );
  }
}
