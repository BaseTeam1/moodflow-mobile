import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/app_storage.dart';
import '../../../core/utils/validators.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required ApiClient api, required this._storage})
      : _dio = api.dio;

  final Dio _dio;
  final AppStorage _storage;

  static Options get _noAuth => Options(extra: {ApiClient.skipAuth: true});

  @override
  Future<void> register(RegistrationData data) async {
    final under14 = isUnder14(data.birthDate);
    await _call(() => _dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: {
            'first_name': data.firstName.trim(),
            'email': data.email.trim(),
            'password': data.password,
            'birth_date': formatApiDate(data.birthDate),
            if (under14) 'parent_email': data.parentEmail?.trim(),
            'parent_consent_confirmed': under14 && data.parentConsentConfirmed,
          },
          options: _noAuth,
        ));
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final response = await _call(() => _dio.post<Map<String, dynamic>>(
          '/auth/login',
          // OAuth2 password form: the email goes in the `username` field.
          data: {'username': email.trim(), 'password': password},
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            extra: {ApiClient.skipAuth: true},
          ),
        ));
    final token = response.data?['access_token'] as String?;
    if (token == null || token.isEmpty) {
      throw const ApiException(
        code: ApiException.unknown,
        message: 'No access token in response',
      );
    }
    await _storage.writeToken(token);
  }

  @override
  Future<User> currentUser() async {
    final response =
        await _call(() => _dio.get<Map<String, dynamic>>('/auth/me'));
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<bool> hasToken() async {
    final t = await _storage.readToken();
    return t != null && t.isNotEmpty;
  }

  @override
  Future<void> logout() => _storage.deleteToken();

  @override
  Future<bool> isOnboardingSeen() => _storage.isOnboardingSeen();

  @override
  Future<void> markOnboardingSeen() => _storage.markOnboardingSeen();

  Future<Response<T>> _call<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
