import 'package:dio/dio.dart';

/// Error returned by the MoodFlow API or by the network layer.
///
/// The backend always answers errors as
/// `{"error": {"code": "...", "message": "...", "details": ...}}`.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
  });

  /// Backend error code (`invalid_credentials`, `email_already_registered`,
  /// `validation_error`, ...) or one of the local codes below.
  final String code;
  final String message;
  final int? statusCode;
  final Object? details;

  static const network = 'network_error';
  static const unknown = 'unknown_error';

  bool get isNetwork => code == network;

  /// Field names the server rejected on 422 (`["body", "password"]` -> `password`).
  List<String> get invalidFields {
    final d = details;
    if (d is! List) return const [];
    final fields = <String>[];
    for (final item in d) {
      if (item is Map && item['loc'] is List) {
        final loc = item['loc'] as List;
        if (loc.isNotEmpty && loc.last is String) fields.add(loc.last as String);
      }
    }
    return fields;
  }

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      return ApiException(
        code: (err['code'] as String?) ?? unknown,
        message: (err['message'] as String?) ?? '',
        statusCode: status,
        details: err['details'],
      );
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ApiException(code: network, message: 'No connection');
      default:
        return ApiException(
          code: unknown,
          message: e.message ?? 'Unexpected error',
          statusCode: status,
        );
    }
  }

  @override
  String toString() => 'ApiException($code, $statusCode)';
}
