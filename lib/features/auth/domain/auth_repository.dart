import 'user.dart';

/// Data needed to create an account (POST /auth/register).
class RegistrationData {
  const RegistrationData({
    required this.firstName,
    required this.email,
    required this.password,
    required this.birthDate,
    this.parentEmail,
    this.parentConsentConfirmed = false,
  });

  final String firstName;
  final String email;
  final String password;
  final DateTime birthDate;

  /// Only for users under 14 (BR8).
  final String? parentEmail;
  final bool parentConsentConfirmed;
}

/// Authentication use cases. Implementations throw `ApiException` on failure.
abstract interface class AuthRepository {
  Future<void> register(RegistrationData data);

  /// Exchanges credentials for an access token and stores it.
  Future<void> login({required String email, required String password});

  /// Loads the profile of the stored token's owner (GET /auth/me).
  Future<User> currentUser();

  Future<bool> hasToken();

  /// Ends the session on this device (the token is deleted locally;
  /// the backend has no logout endpoint).
  Future<void> logout();

  Future<bool> isOnboardingSeen();

  Future<void> markOnboardingSeen();
}
