import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/mood_palette.dart';

class MoodNavItem {
  const MoodNavItem({required this.asset, required this.label});

  /// SVG from the Figma UI-kit (`assets/icons/nav_*.svg`), tinted at runtime.
  final String asset;
  final String label;
}

/// Floating rounded navigation bar; the selected item sits in a light circle.
class MoodNavBar extends StatelessWidget {
  const MoodNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.palette,
  });

  final List<MoodNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final MoodPalette palette;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: palette.navBar,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  palette: palette,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final MoodNavItem item;
  final bool selected;
  final MoodPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected && Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : palette.text;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            // Wide enough for "Компаньйон"; the label shrinks on narrow phones.
            constraints: const BoxConstraints(minWidth: 64, maxWidth: 84),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: selected ? palette.navSelected : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.asset,
                  height: 24,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.inter(fontSize: 10, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
