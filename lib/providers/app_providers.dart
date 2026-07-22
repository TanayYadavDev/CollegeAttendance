import 'package:college_attendance/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  // TODO: Initialize notification service with platform-specific setup.
  return NotificationService();
});
