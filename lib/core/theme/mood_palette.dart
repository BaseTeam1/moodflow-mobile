import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Screen-level colours that Material's ColorScheme does not cover
/// (gradients, field and button styling from the mockups).
@immutable
class MoodPalette extends ThemeExtension<MoodPalette> {
  const MoodPalette({
    required this.background,
    required this.splashBackground,
    required this.panel,
    required this.fieldFill,
    required this.fieldBorder,
    required this.text,
    required this.hint,
    required this.headline,
    required this.buttonFill,
    required this.buttonText,
    required this.pill,
    required this.pillSelected,
    required this.navBar,
    required this.navSelected,
  });

  final Gradient background;
  final Gradient splashBackground;
  final Gradient panel;
  final Color fieldFill;
  final Color fieldBorder;
  final Color text;
  final Color hint;
  final Color headline;
  final Color buttonFill;
  final Color buttonText;
  final Color pill;
  final Color pillSelected;
  final Color navBar;
  final Color navSelected;

  /// Light theme: radial lavender gradient (#7672AA → #9998C3 → #BCBEDC).
  static const light = MoodPalette(
    background: RadialGradient(
      radius: 0.95,
      colors: [AppColors.lavender, AppColors.lavenderMid, AppColors.lavenderLight],
      stops: [0, 0.5, 1],
    ),
    splashBackground: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6C63C7), AppColors.lavender, AppColors.lavenderLight, AppColors.mist],
      stops: [0, 0.35, 0.75, 1],
    ),
    panel: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFC9CAE4), AppColors.lavender],
    ),
    fieldFill: AppColors.lavenderLight,
    fieldBorder: Colors.black,
    text: Colors.black,
    hint: Color(0x78000000),
    headline: AppColors.navy,
    buttonFill: AppColors.buttonTint,
    buttonText: AppColors.mist,
    pill: Color(0xB3EEF2FF),
    pillSelected: AppColors.lavender,
    navBar: Color(0x667672AA),
    navSelected: AppColors.mist,
  );

  /// Dark theme: deep navy gradient (#10112B → #000017).
  static const dark = MoodPalette(
    background: RadialGradient(
      center: Alignment(0, -0.2),
      radius: 1.1,
      colors: [AppColors.nightSoft, AppColors.ink],
    ),
    splashBackground: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.indigoDeep, AppColors.night, AppColors.ink],
    ),
    panel: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.indigoDeep, AppColors.night],
    ),
    fieldFill: Colors.transparent,
    fieldBorder: AppColors.indigo,
    text: AppColors.mist,
    hint: AppColors.lavenderLight,
    headline: AppColors.mist,
    buttonFill: AppColors.indigoDeep,
    buttonText: AppColors.mist,
    pill: AppColors.indigo,
    pillSelected: AppColors.lavender,
    navBar: AppColors.indigoDeep,
    navSelected: AppColors.lavender,
  );

  static MoodPalette of(BuildContext context) =>
      Theme.of(context).extension<MoodPalette>() ?? light;

  @override
  MoodPalette copyWith({
    Gradient? background,
    Gradient? splashBackground,
    Gradient? panel,
    Color? fieldFill,
    Color? fieldBorder,
    Color? text,
    Color? hint,
    Color? headline,
    Color? buttonFill,
    Color? buttonText,
    Color? pill,
    Color? pillSelected,
    Color? navBar,
    Color? navSelected,
  }) {
    return MoodPalette(
      background: background ?? this.background,
      splashBackground: splashBackground ?? this.splashBackground,
      panel: panel ?? this.panel,
      fieldFill: fieldFill ?? this.fieldFill,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      text: text ?? this.text,
      hint: hint ?? this.hint,
      headline: headline ?? this.headline,
      buttonFill: buttonFill ?? this.buttonFill,
      buttonText: buttonText ?? this.buttonText,
      pill: pill ?? this.pill,
      pillSelected: pillSelected ?? this.pillSelected,
      navBar: navBar ?? this.navBar,
      navSelected: navSelected ?? this.navSelected,
    );
  }

  @override
  MoodPalette lerp(ThemeExtension<MoodPalette>? other, double t) {
    if (other is! MoodPalette) return this;
    return MoodPalette(
      background: Gradient.lerp(background, other.background, t)!,
      splashBackground: Gradient.lerp(splashBackground, other.splashBackground, t)!,
      panel: Gradient.lerp(panel, other.panel, t)!,
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      text: Color.lerp(text, other.text, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      headline: Color.lerp(headline, other.headline, t)!,
      buttonFill: Color.lerp(buttonFill, other.buttonFill, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
      pill: Color.lerp(pill, other.pill, t)!,
      pillSelected: Color.lerp(pillSelected, other.pillSelected, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
    );
  }
}
