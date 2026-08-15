import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../controllers/settings_controller.dart';
import '../widgets/setting_tile.dart';
import 'login_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController _controller = SettingsController();
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _refreshLoginState();
  }

  Future<void> _refreshLoginState() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<bool> _login(String registrationNo, String password) async {
    setState(() {
      _isAuthenticating = true;
    });

    final isSuccess = await _authService.login(
      registrationNo: registrationNo,
      password: password,
    );

    if (!mounted) {
      return false;
    }

    setState(() {
      _isLoggedIn = isSuccess;
      _isAuthenticating = false;
    });

    return isSuccess;
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggedIn = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 61, 138),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0752A8),
              Color(0xFF023D89),
            ],
          ),
        ),
        child: _isLoggedIn
            ? ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SettingTile(
              title: 'Account',
              subtitle: 'Logged in',
              leading: Icons.account_circle_outlined,
              onTap: _logout,
            ),
            SettingTile(
              title: 'Notifications',
              subtitle: _controller.notificationsEnabled
                  ? 'Enabled'
                  : 'Disabled',
              leading: Icons.notifications_outlined,
              onTap: () {
                setState(() {
                  _controller.toggleNotifications();
                });
              },
            ),
            SettingTile(
              title: 'Dark Mode',
              subtitle:
              _controller.darkModeEnabled ? 'Enabled' : 'Disabled',
              leading: Icons.dark_mode_outlined,
              onTap: () {
                setState(() {
                  _controller.toggleDarkMode();
                });
              },
            ),
          ],
        )
      : LoginView(
          onLogin: _login,
          isLoading: _isAuthenticating,
        ),
      ),
    );
  }
}