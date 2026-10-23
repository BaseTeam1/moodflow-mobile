abstract final class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  /// Screens that only signed-out users see.
  static const publicOnly = {splash, onboarding, login, register};
}
