class SettingsController {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  void toggleNotifications() {
    notificationsEnabled = !notificationsEnabled;
  }

  void toggleDarkMode() {
    darkModeEnabled = !darkModeEnabled;
  }
}