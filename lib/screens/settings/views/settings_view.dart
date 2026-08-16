import 'package:flutter/material.dart';

import '../../../models/student_profile.dart';
import '../../../services/auth_service.dart';
import '../../../services/samarth_service.dart';
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

  late final SamarthService _samarthService;

  bool _isLoggedIn = false;
  bool _isAuthenticating = false;

  StudentProfile? _studentProfile;

  @override
  void initState() {
    super.initState();

    _samarthService = SamarthService(
      _authService.client,
    );

    _refreshLoginState();
  }

  Future<void> _refreshLoginState() async {
    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) {
      return;
    }

    if (isLoggedIn) {
      final profile = await _samarthService.getStudentProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoggedIn = true;
        _studentProfile = profile;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _studentProfile = null;
      });
    }
  }

  Future<bool> _login(
      String registrationNo,
      String password,
      ) async {
    setState(() {
      _isAuthenticating = true;
    });

    final isSuccess = await _authService.login(
      registrationNo: registrationNo,
      password: password,
    );

    StudentProfile? profile;

    if (isSuccess) {
      profile = await _samarthService.getStudentProfile();
    }

    if (!mounted) {
      return false;
    }

    setState(() {
      _isLoggedIn = isSuccess;
      _isAuthenticating = false;
      _studentProfile = profile;
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
      _studentProfile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out'),
      ),
    );
  }

  void _showAccountProfile() {
    final profile = _studentProfile;

    if (profile == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AccountProfileSheet(
          profile: profile,
          onLogout: _logout,
        );
      },
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
              title: _studentProfile?.name ?? 'Account',
              subtitle: _studentProfile?.registrationNo ??
                  'Logged in',
              leading: Icons.account_circle_outlined,
              onTap: _showAccountProfile,
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
              subtitle: _controller.darkModeEnabled
                  ? 'Enabled'
                  : 'Disabled',
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

class _AccountProfileSheet extends StatelessWidget {
  const _AccountProfileSheet({
    required this.profile,
    required this.onLogout,
  });

  final StudentProfile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 24),

            ClipOval(
              child: SizedBox(
                width: 96,
                height: 96,
                child: profile.photoUrl != null
                    ? Image.network(
                  profile.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFC4E1FF),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 52,
                        color: Color(0xFF0752A8),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: const Color(0xFFC4E1FF),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  color: const Color(0xFFC4E1FF),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: Color(0xFF0752A8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              profile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              profile.registrationNo,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.55),
              ),
            ),

            const SizedBox(height: 22),

            _ProfileDetail(
              icon: Icons.school_outlined,
              label: 'Programme',
              value: profile.programme,
            ),

            _ProfileDetail(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile.email,
            ),

            if (profile.mobileNumber.isNotEmpty)
              _ProfileDetail(
                icon: Icons.phone_outlined,
                label: 'Mobile',
                value: profile.mobileNumber,
              ),

            _ProfileDetail(
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: profile.dateOfBirth,
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onLogout();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: const Color(0xFF0752A8),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.50),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}