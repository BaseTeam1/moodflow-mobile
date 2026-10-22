import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small wrapper over the platform secure storage (Keychain / Keystore).
///
/// The access token lives only here (Definition of Done: never in logs or
/// plain preferences).
class AppStorage {
  AppStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'access_token';
  static const _onboardingKey = 'onboarding_seen';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  Future<bool> isOnboardingSeen() async =>
      (await _storage.read(key: _onboardingKey)) == 'true';

  Future<void> markOnboardingSeen() =>
      _storage.write(key: _onboardingKey, value: 'true');
}
