import 'package:flutter/material.dart';

import '../theme/mood_palette.dart';

/// Full-screen background used by every screen in the mockups.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child, this.splash = false});

  final Widget child;

  /// The onboarding/splash screens use a brighter diagonal gradient.
  final bool splash;

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: splash ? p.splashBackground : p.background,
      ),
      child: child,
    );
  }
}
