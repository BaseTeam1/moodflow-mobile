import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/mood_logo.dart';
import '../auth/presentation/session/session_cubit.dart';

/// Start screen. Figma: Page 2, frame "iPhone 13 & 14 - 79" (node 588:1556).
/// "Розпочати" marks onboarding as seen; the router then opens the login screen.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        splash: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const MoodLogo(size: 300),
                const SizedBox(height: 8),
                SvgPicture.asset(
                  'assets/images/wordmark.svg',
                  width: 204,
                  semanticsLabel: 'MoodFlow',
                ),
                const SizedBox(height: 16),
                Text(
                  'Твій провідник для емоційного балансу.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Розумій себе краще з кожним днем.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(flex: 3),
                _StartButton(
                  onPressed: () =>
                      context.read<SessionCubit>().completeOnboarding(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Translucent 340×56 button with a light border, as in the mockup.
class _StartButton extends StatelessWidget {
  const _StartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      color: AppColors.mist.withValues(alpha: 0.85),
    );
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: AppColors.indigoDeep.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.mist.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Розпочати', style: style),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: style.color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
