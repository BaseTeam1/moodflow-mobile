import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../storage/app_storage.dart';

/// Creates the shared [Dio] instance.
///
/// * attaches `Authorization: Bearer <token>` to every request, unless the
///   request sets `extra: {'skipAuth': true}` (login, register);
/// * when an authorised request comes back 401 (token expired after 60 min or
///   account deactivated), deletes the token and calls [onUnauthorized].
class ApiClient {
  ApiClient({
    required this._storage,
    required bool isAndroid,
    Dio? dio,
  }) : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl(isAndroid: isAndroid),
                connectTimeout: AppConfig.connectTimeout,
                receiveTimeout: AppConfig.receiveTimeout,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            ) {
    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: _attachToken,
            onError: _handleError,
          ),
        );
  }

  final Dio dio;
  final AppStorage _storage;

  /// Set by the session layer; called once the stored token is no longer valid.
  void Function()? onUnauthorized;

  static const skipAuth = 'skipAuth';

  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _storage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<void> _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      // Debug console only; never logs request bodies (passwords).
      final o = error.requestOptions;
      debugPrint('API ${o.method} ${o.uri} failed: ${error.type.name} '
          'status=${error.response?.statusCode} ${error.message ?? ''}');
    }
    final wasAuthorised =
        error.requestOptions.headers.containsKey('Authorization');
    if (error.response?.statusCode == 401 && wasAuthorised) {
      await _storage.deleteToken();
      onUnauthorized?.call();
    }
    handler.next(error);
  }
}
