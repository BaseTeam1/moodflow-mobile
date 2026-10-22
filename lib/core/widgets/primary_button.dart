import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/mood_palette.dart';

/// Main action button from the mockups: full width, 46 px high,
/// 10 px corners, Inter Bold 20.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.trailingIcon,
    this.height = 46,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? trailingIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    final style = AppText.button(p);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: p.buttonFill,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: loading ? null : onPressed,
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: p.buttonText,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: style),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(trailingIcon, color: style.color, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
