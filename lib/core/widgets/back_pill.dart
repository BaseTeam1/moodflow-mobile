import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/mood_palette.dart';

/// "< Повернутись до входу" pill in the top-left corner.
class BackPill extends StatelessWidget {
  const BackPill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    return Material(
      color: p.buttonFill,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left, size: 18, color: p.text),
              Text(label, style: AppText.small(p)),
            ],
          ),
        ),
      ),
    );
  }
}
