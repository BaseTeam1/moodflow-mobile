import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/register/register_screen.dart';
import '../../features/auth/presentation/session/session_cubit.dart';
import '../../features/home/home_shell.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import 'routes.dart';

/// Routes guarded by the session state:
/// * unknown → splash while the stored token is checked;
/// * signed out → onboarding (first launch) or login; Home is closed (US-06, AC 2);
/// * signed in → Home; auth screens are closed.
GoRouter buildRouter(SessionCubit session) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: _CubitListenable(session),
    redirect: (context, state) {
      final s = session.state;
      final loc = state.matchedLocation;

      switch (s.status) {
        case SessionStatus.unknown:
          return loc == Routes.splash ? null : Routes.splash;
        case SessionStatus.authenticated:
          return Routes.publicOnly.contains(loc) ? Routes.home : null;
        case SessionStatus.unauthenticated:
          final entry = s.onboardingSeen ? Routes.login : Routes.onboarding;
          if (loc == Routes.splash || loc == Routes.home) return entry;
          if (loc == Routes.onboarding && s.onboardingSeen) return Routes.login;
          return null;
      }
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: Routes.home, builder: (_, _) => const HomeShell()),
    ],
  );
}

/// Lets GoRouter re-run `redirect` whenever the session changes.
class _CubitListenable extends ChangeNotifier {
  _CubitListenable(SessionCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<SessionState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
