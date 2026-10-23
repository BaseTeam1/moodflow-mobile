import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'mood_palette.dart';

/// Light and dark themes built from the Figma mockups.
///
/// Body text in the mockups is Inter; headlines use "e-Ukraine Head" Bold.
/// e-Ukraine Head is not on Google Fonts, so headlines fall back to Inter
/// ExtraBold until the font files are added to `assets/fonts/` (see README).
abstract final class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        palette: MoodPalette.light,
        scheme: const ColorScheme.light(
          primary: AppColors.lavender,
          onPrimary: AppColors.mist,
          secondary: AppColors.accent,
          onSecondary: AppColors.mist,
          error: AppColors.error,
          onError: Colors.white,
          surface: AppColors.mist,
          onSurface: Colors.black,
        ),
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        palette: MoodPalette.dark,
        scheme: const ColorScheme.dark(
          primary: AppColors.lavender,
          onPrimary: AppColors.mist,
          secondary: AppColors.accent,
          onSecondary: AppColors.mist,
          error: AppColors.error,
          onError: Colors.white,
          surface: AppColors.night,
          onSurface: AppColors.mist,
        ),
      );

  static ThemeData _build({
    required Brightness brightness,
    required MoodPalette palette,
    required ColorScheme scheme,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
    );
    // Inter for every style; applied through fontFamily so the TextTheme
    // stays the one ThemeData expects.
    final text = base.textTheme.apply(
      fontFamily: GoogleFonts.inter().fontFamily,
      bodyColor: palette.text,
      displayColor: palette.text,
    );
    return base.copyWith(
      textTheme: text,
      extensions: [palette],
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.indigoDeep,
        contentTextStyle: GoogleFonts.inter(color: AppColors.mist, fontSize: 14),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: palette.fieldBorder),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.lavender
              : Colors.transparent,
        ),
      ),
    );
  }
}

/// Text styles taken from the mockups (sizes in logical pixels).
abstract final class AppText {
  /// "Вхід до акаунту", "Створити акаунт": e-Ukraine Head Bold 24.
  static TextStyle headline(MoodPalette p) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: p.headline,
        height: 1.2,
      );

  /// Subtitle and field labels: Inter Regular 16.
  static TextStyle body(MoodPalette p) =>
      GoogleFonts.inter(fontSize: 16, color: p.text);

  static TextStyle hint(MoodPalette p) =>
      GoogleFonts.inter(fontSize: 16, color: p.hint);

  /// Primary button label: Inter Bold 20.
  static TextStyle button(MoodPalette p) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: p.buttonText,
      );

  /// Small links ("Забули пароль?", "Повернутись до входу"): Inter 14.
  static TextStyle small(MoodPalette p, {FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.inter(fontSize: 14, fontWeight: weight, color: p.text);

  static TextStyle error() =>
      GoogleFonts.inter(fontSize: 13, color: AppColors.error, height: 1.3);
}
