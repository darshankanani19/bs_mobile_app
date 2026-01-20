import 'dart:convert';
import 'package:bs/Core/Util/api_end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:bs/core/helper/storage_helper.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiInterceptors {
  final Dio _dio;

  // These variables prevent multiple refresh calls happening at the same time
  bool _isRefreshing = false;
  Future<bool>? _refreshFuture;

  ApiInterceptors({required Dio dio}) : _dio = dio;

  InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      /// 1. ON REQUEST: Check token and refresh 4 minutes before expiry
      onRequest: (options, handler) async {
        final token = await StorageHelper.getAccessToken();

        if (token != null && token.isNotEmpty) {
          try {
            // Check if token is expired OR expires in less than 4 minutes
            bool isAboutToExpire =
                JwtDecoder.getRemainingTime(token).inMinutes < 4;

            if (isAboutToExpire) {
              debugPrint(
                "🕒 Token expiring soon (within 4 mins). Refreshing...",
              );

              // This waits for the refresh logic to complete safely
              final success = await _getRefreshLogic();

              if (success) {
                final newToken = await StorageHelper.getAccessToken();
                options.headers['Authorization'] = 'Bearer $newToken';
              }
            } else {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            // If token is invalid/malformed, just attach what we have
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },

      /// 2. ON RESPONSE: Handle successful data and wrap in ApiResult
      onResponse: (response, handler) async {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          response.data = ApiResult.success(
            data: data,
            status: response.statusCode,
          );
          return handler.next(response);
        }

        // If status is not 200/201, reject so onError can handle it
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      },

      /// 3. ON ERROR: Backup logic for 401 Unauthorized errors
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains('token/refresh')) {
          final success = await _getRefreshLogic();

          if (success) {
            final newToken = await StorageHelper.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            // Retry the original failed request
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        return handler.reject(error);
      },
    );
  }

  /// Thread-safe refresh logic (Synchronizes multiple parallel requests)
  Future<bool> _getRefreshLogic() async {
    if (_isRefreshing) {
      // If a refresh is already in progress, wait for the existing one
      return _refreshFuture ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshFuture = _refreshToken(); // Start the API call

    final result = await _refreshFuture;

    _isRefreshing = false;
    _refreshFuture = null;
    return result ?? false;
  }

  /// The actual API call to the server
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageHelper.getRefreshToken();
      if (refreshToken == null) return false;

      // Use a new Dio instance here to avoid interceptor loops
      final response = await Dio().post(
        ApiEndPoints.refreshToken,
        data: {"refresh": refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccess = response.data['access'];
        await StorageHelper.saveAccessToken(newAccess);
        debugPrint("✅ Token refreshed successfully.");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Refresh Token failed: $e");
      await StorageHelper.logout();
      return false;
    }
  }
}
