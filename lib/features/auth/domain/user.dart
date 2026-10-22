import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.birthDate,
    this.firstName,
    this.parentEmail,
    this.isActive = true,
  });

  final String id;
  final String email;
  final String? firstName;
  final DateTime birthDate;
  final String? parentEmail;
  final bool isActive;

  /// Name for greetings; falls back to the part of the email before "@".
  String get displayName {
    final n = firstName?.trim();
    if (n != null && n.isNotEmpty) return n;
    return email.split('@').first;
  }

  @override
  List<Object?> get props => [id, email, firstName, birthDate, parentEmail, isActive];
}
