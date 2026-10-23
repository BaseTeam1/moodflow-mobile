import '../domain/user.dart';

/// JSON shape of `UserResponse` from the backend.
abstract final class UserDto {
  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['first_name'] as String?,
        birthDate: DateTime.parse(json['birth_date'] as String),
        parentEmail: json['parent_email'] as String?,
        isActive: (json['is_active'] as bool?) ?? true,
      );
}

/// `YYYY-MM-DD`, the format of Pydantic `date`.
String formatApiDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
