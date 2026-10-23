import 'package:flutter/material.dart';

/// Palette from the Figma UI-kit (BA common board → Page 2 → UI-kit).
abstract final class AppColors {
  static const ink = Color(0xFF000017);
  static const night = Color(0xFF0D0D27);
  static const nightSoft = Color(0xFF10112B);
  static const indigoDeep = Color(0xFF2E2E5C);
  static const indigo = Color(0xFF454576);
  static const lavender = Color(0xFF7672AA);
  static const lavenderMid = Color(0xFF9998C3);
  static const lavenderLight = Color(0xFFBCBEDC);
  static const mist = Color(0xFFEEF2FF);

  static const accent = Color(0xFF4338CC);
  static const success = Color(0xFF16A34A);
  static const error = Color(0xFFEF4444);

  /// Headline colour on light screens ("Вхід до акаунту").
  static const navy = Color(0xFF11224F);

  /// Button fill on light screens: rgba(17, 34, 80, 0.2).
  static const buttonTint = Color(0x33112250);
}
