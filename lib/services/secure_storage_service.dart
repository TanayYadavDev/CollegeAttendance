import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _registrationKey = 'registration_no';
  static const String _passwordKey = 'password';

  final FlutterSecureStorage _storage;

  const SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveCredentials({
    required String registrationNo,
    required String password,
  }) async {
    await _storage.write(key: _registrationKey, value: registrationNo);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<Map<String, String>?> getCredentials() async {
    final registrationNo = await _storage.read(key: _registrationKey);
    final password = await _storage.read(key: _passwordKey);

    if (registrationNo == null || password == null) {
      return null;
    }

    return <String, String>{
      _registrationKey: registrationNo,
      _passwordKey: password,
    };
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _registrationKey);
    await _storage.delete(key: _passwordKey);
  }
}