/// Client-side checks that mirror the backend rules (UserRegisterRequest),
/// so the user sees the problem before the request is sent.
abstract final class Validators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _letter = RegExp(r'\p{L}', unicode: true);
  static final _digit = RegExp(r'\d');

  static const passwordMin = 8;
  static const passwordMax = 128;
  static const nameMax = 100;

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Введіть email';
    if (!_email.hasMatch(v)) return 'Некоректний email';
    return null;
  }

  /// Login only checks that the field is filled: the server decides the rest.
  static String? requiredPassword(String? value) =>
      (value == null || value.isEmpty) ? 'Введіть пароль' : null;

  /// Registration rule (US-01, BR6): 8–128 characters, at least one letter
  /// and one digit.
  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Введіть пароль';
    if (v.length < passwordMin) return 'Мінімум $passwordMin символів';
    if (v.length > passwordMax) return 'Максимум $passwordMax символів';
    if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) {
      return 'Пароль має містити хоча б одну літеру й одну цифру';
    }
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Введіть ім'я";
    if (v.length > nameMax) return 'Максимум $nameMax символів';
    return null;
  }

  static String? birthDate(DateTime? value, {DateTime? today}) {
    if (value == null) return 'Оберіть дату народження';
    final now = today ?? DateTime.now();
    if (value.isAfter(now)) return 'Дата не може бути в майбутньому';
    if (value.year < now.year - 120) return 'Перевірте рік народження';
    return null;
  }
}

/// Age in full years, the same way the backend counts it (`is_under_14`).
int ageOn(DateTime birthDate, DateTime today) {
  var age = today.year - birthDate.year;
  final hadBirthday = (today.month > birthDate.month) ||
      (today.month == birthDate.month && today.day >= birthDate.day);
  if (!hadBirthday) age -= 1;
  return age;
}

/// BR8: users under 14 need a parent's or guardian's email and consent.
bool isUnder14(DateTime? birthDate, {DateTime? today}) {
  if (birthDate == null) return false;
  return ageOn(birthDate, today ?? DateTime.now()) < 14;
}
