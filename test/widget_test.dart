// Unit tests for sprint 1 client logic (no network, no fonts needed).
//
// Run: flutter test

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodflow_mobile/core/network/api_exception.dart';
import 'package:moodflow_mobile/core/network/error_messages.dart';
import 'package:moodflow_mobile/core/utils/validators.dart';
import 'package:moodflow_mobile/features/auth/data/user_dto.dart';

void main() {
  group('Validators.newPassword (US-01)', () {
    test('accepts 8+ characters with a letter and a digit', () {
      expect(Validators.newPassword('secret12'), isNull);
      expect(Validators.newPassword('пароль12'), isNull);
    });

    test('rejects short, letter-only and digit-only passwords', () {
      expect(Validators.newPassword('abc12'), isNotNull);
      expect(Validators.newPassword('abcdefgh'), isNotNull);
      expect(Validators.newPassword('12345678'), isNotNull);
      expect(Validators.newPassword(''), isNotNull);
    });

    test('rejects passwords longer than 128 characters', () {
      expect(Validators.newPassword('a1' * 65), isNotNull);
    });
  });

  group('Validators.email', () {
    test('accepts a normal address', () {
      expect(Validators.email('name@example.com'), isNull);
    });

    test('rejects empty and malformed values', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('name@'), isNotNull);
      expect(Validators.email('name example.com'), isNotNull);
    });
  });

  group('isUnder14 (BR8), same rule as the backend', () {
    final today = DateTime(2026, 10, 23);

    test('13 years old is under 14', () {
      expect(isUnder14(DateTime(2012, 10, 24), today: today), isTrue);
    });

    test('exactly 14 today is not under 14', () {
      expect(isUnder14(DateTime(2012, 10, 23), today: today), isFalse);
    });

    test('adult is not under 14', () {
      expect(isUnder14(DateTime(2000, 1, 1), today: today), isFalse);
    });

    test('no date means no extra fields', () {
      expect(isUnder14(null, today: today), isFalse);
    });
  });

  group('Validators.birthDate', () {
    final today = DateTime(2026, 10, 23);

    test('requires a date in the past', () {
      expect(Validators.birthDate(null, today: today), isNotNull);
      expect(Validators.birthDate(DateTime(2027, 1, 1), today: today), isNotNull);
      expect(Validators.birthDate(DateTime(2007, 1, 1), today: today), isNull);
    });
  });

  group('ApiException.fromDio', () {
    DioException errorWith(int status, Object data) {
      final options = RequestOptions(path: '/auth/login');
      return DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: status, data: data),
        type: DioExceptionType.badResponse,
      );
    }

    test('reads the backend error envelope', () {
      final e = ApiException.fromDio(errorWith(401, {
        'error': {'code': 'invalid_credentials', 'message': 'x', 'details': null},
      }));
      expect(e.code, 'invalid_credentials');
      expect(e.statusCode, 401);
      expect(errorMessage(e), 'Невірний email або пароль');
    });

    test('lists invalid fields from a 422 response', () {
      final e = ApiException.fromDio(errorWith(422, {
        'error': {
          'code': 'validation_error',
          'message': 'Request validation failed',
          'details': [
            {'loc': ['body', 'password'], 'msg': 'too short', 'type': 'string_too_short'},
          ],
        },
      }));
      expect(e.invalidFields, ['password']);
    });

    test('maps connection problems to a network error', () {
      final e = ApiException.fromDio(DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        type: DioExceptionType.connectionError,
      ));
      expect(e.isNetwork, isTrue);
    });
  });

  group('UserDto', () {
    test('parses UserResponse', () {
      final user = UserDto.fromJson({
        'id': '8b2d2a52-1d2f-4c1e-9a55-3b0c3f6f2a10',
        'first_name': 'Аліса',
        'email': 'alisa@example.com',
        'birth_date': '2005-03-14',
        'parent_consent_confirmed': false,
        'parent_email': null,
        'is_active': true,
        'created_at': '2026-10-22T10:00:00Z',
        'updated_at': '2026-10-22T10:00:00Z',
      });
      expect(user.displayName, 'Аліса');
      expect(user.birthDate, DateTime(2005, 3, 14));
    });

    test('formats dates for the API', () {
      expect(formatApiDate(DateTime(2012, 1, 5)), '2012-01-05');
    });
  });
}
