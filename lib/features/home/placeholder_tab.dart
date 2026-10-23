import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/mood_palette.dart';

/// Tabs that are planned for later sprints.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 24, 25, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.headline(p)),
          const Spacer(),
          Center(
            child: Text(text, textAlign: TextAlign.center, style: AppText.body(p)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
