/// Build-time configuration.
///
/// Override the backend address with `--dart-define`, for example:
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.105:8000/api/v1
///
/// Defaults:
///   * Android emulator reaches the host machine at 10.0.2.2;
///   * iOS simulator reaches it at localhost.
class AppConfig {
  const AppConfig._();

  static const String _fromEnv = String.fromEnvironment('API_BASE_URL');

  static String apiBaseUrl({required bool isAndroid}) {
    if (_fromEnv.isNotEmpty) return _fromEnv;
    return isAndroid
        ? 'http://10.0.2.2:8000/api/v1'
        : 'http://localhost:8000/api/v1';
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
