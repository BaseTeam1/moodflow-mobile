import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/mood_palette.dart';

/// Labelled input from the mockups: label (Inter 16) above a 340×56 field
/// with a leading icon, 1 px border and 10 px corners.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.errorText,
    this.suffix,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;

  /// Error from the server, shown under the field like a validation error.
  final String? errorText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final p = MoodPalette.of(context);
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c, width: w),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(label, style: AppText.body(p)),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          enabled: enabled,
          style: AppText.body(p),
          cursorColor: p.text,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: p.fieldFill,
            hintText: hint,
            hintStyle: AppText.hint(p),
            errorText: errorText,
            errorStyle: AppText.error(),
            errorMaxLines: 3,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(icon, size: 20, color: p.text),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 20),
            suffixIcon: suffix,
            border: border(p.fieldBorder),
            enabledBorder: border(p.fieldBorder),
            disabledBorder: border(p.fieldBorder.withValues(alpha: 0.4)),
            focusedBorder: border(AppColors.accent, 1.5),
            errorBorder: border(AppColors.error),
            focusedErrorBorder: border(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }
}
