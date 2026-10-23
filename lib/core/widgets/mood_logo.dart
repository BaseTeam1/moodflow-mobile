import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// MoodFlow mascot (drop with a smiling face).
///
/// The artwork must be exported from Figma to `assets/images/logo.png`
/// (transparent PNG, 3x). Until then a neutral placeholder is drawn so the
/// app still runs.
class MoodLogo extends StatelessWidget {
  const MoodLogo({super.key, this.size = 220});

  final double size;

  static const asset = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => _Placeholder(size: size),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.8,
      height: size * 0.8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.mist, AppColors.lavender],
        ),
        border: Border.all(color: AppColors.indigoDeep, width: size * 0.03),
      ),
      child: Icon(
        Icons.sentiment_satisfied_alt_rounded,
        size: size * 0.45,
        color: AppColors.indigoDeep,
      ),
    );
  }
}
