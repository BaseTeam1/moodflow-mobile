import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/mood_logo.dart';

/// Shown while the stored session is being checked on launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        splash: true,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MoodLogo(size: 200),
              SizedBox(height: 32),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.mist,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
