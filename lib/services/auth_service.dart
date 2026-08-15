import 'secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorageService;

  const AuthService({SecureStorageService? secureStorageService})
    : _secureStorageService = secureStorageService ?? const SecureStorageService();

  Future<bool> login({
    required String registrationNo,
    required String password,
  }) async {
    final normalizedRegistrationNo = registrationNo.trim();

    if (normalizedRegistrationNo.isEmpty || password.isEmpty) {
      return false;
    }

    if (password.length < 4) {
      return false;
    }

    await _secureStorageService.saveCredentials(
      registrationNo: normalizedRegistrationNo,
      password: password,
    );

    return true;
  }

  Future<void> logout() async {
    await _secureStorageService.clearCredentials();
  }

  Future<bool> isLoggedIn() async {
    final credentials = await _secureStorageService.getCredentials();
    return credentials != null;
  }
}