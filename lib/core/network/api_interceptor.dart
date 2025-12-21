// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:beauty_salon/core/network/api_result.dart';
// import 'package:beauty_salon/core/network/api_header.dart';
// import 'package:beauty_salon/core/utils/api_end_points.dart';
//
// class ApiInterceptors {
//   getInterceptor() {
//     return InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final prefs = await SharedPreferences.getInstance();
//         final resetToken = prefs.getString('resetToken');
//
//         List<String> ignoreAuthTokenEndpoints = [
//           ApiEndPoints.login,
//           ApiEndPoints.signup,
//
//         ];
//
//         String resetPasswordEndpoint = ApiEndPoints.resetPassword;
//
//         debugPrint('Request Path: ${options.path}');
//
//         Map<String, dynamic> headers;
//
//         // 1. Use reset token only for reset password endpoint
//         if (options.path == resetPasswordEndpoint && resetToken != null && resetToken.isNotEmpty) {
//           headers = {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $resetToken',
//           };
//         } else {
//           // 2. Use standard auth token from StorageHelper
//           headers = await ApiHeaders.getHeaders();
//         }
//
//         // 3. Merge existing headers from options
//         headers.addAll(options.headers);
//         options.headers = headers;
//
//         return handler.next(options);
//       },
//
//       onResponse: (response, handler) async {
//         var data = response.data;
//         if (response.data.runtimeType == String) {
//           data = jsonDecode(data);
//         }
//
//         if (response.statusCode == 401) {
//           handleSessionTimeout(response);
//           return handler.next(response);
//         } else if (response.statusCode == 200) {
//           response.data = ApiResult.success(data: data, status: 200);
//         } else {
//           handleInvalidToken(response);
//           response.data = ApiResult.failure(
//             error: data['message'],
//             status: response.statusCode,
//           );
//         }
//
//         return handler.next(response);
//       },
//
//       onError: (e, handler) async {
//         e.response?.data = ApiResult.failure(error: e.toString());
//         return handler.next(e);
//       },
//     );
//   }
//
//   void handleSessionTimeout(Response response) {
//     if (response.data['message'] == 'Unauthorized access.') {
//       // AppRouter().logout(); // Uncomment if logout functionality is implemented
//     }
//   }
//
//   void handleInvalidToken(Response response) {
//     if (response.data['status'] == 0 &&
//         response.data['msg'] == 'Invalid or expired token') {
//       // AppRouter().logout(); // Uncomment if logout functionality is implemented
//     }
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:beauty_salon/core/helper/storage_helper.dart';

import 'package:beauty_salon/core/network/api_result.dart';
import 'package:beauty_salon/core/network/api_header.dart';
import 'package:beauty_salon/core/utils/api_end_points.dart';
// import 'package:beauty_salon/core/helpers/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class ApiInterceptors {
  Dio? _dio;

  ApiInterceptors({Dio? dio}) {
    _dio = dio ?? Dio(); // Used for token refresh
  }

  InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final resetToken = prefs.getString('resetToken');

        List<String> ignoreAuthTokenEndpoints = [
          ApiEndPoints.login,
          ApiEndPoints.signup,
          ApiEndPoints.refreshToken,
        ];

        final resetPasswordEndpoint = ApiEndPoints.resetPassword;

        debugPrint('➡️ Request Path: ${options.path}');

        Map<String, dynamic> headers;

        // 1. Use reset token for reset password endpoint
        if (options.path == resetPasswordEndpoint &&
            resetToken != null &&
            resetToken.isNotEmpty) {
          headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $resetToken',
          };
        } else if (ignoreAuthTokenEndpoints.contains(options.path)) {
          headers = {'Content-Type': 'application/json'};
        } else {
          headers = await ApiHeaders.getHeaders();
        }

        // 2. Merge with existing headers
        headers.addAll(options.headers);
        options.headers = headers;

        return handler.next(options);
      },

      onResponse: (response, handler) async {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (e) {
            print('❌ Failed to decode response: $e');
          }
        }

        print('➡️ Response Status: ${response.statusCode}');
        print('➡️ Response Data: $data');

        if (response.statusCode == 200 || response.statusCode == 201) {
          response.data = ApiResult.success(data: data, status: 200);
        } else {
          print("⚠️ in ee option: non-200 response");
          handleInvalidToken(response);

          final errorMsg =
              data['message'] ?? data['detail'] ?? 'Unknown error occurred';
          print('❌ Error message from server: $errorMsg');

          response.data = ApiResult.failure(
            error: errorMsg,
            status: response.statusCode,
          );
        }

        return handler.next(response);
      },


      onError: (e, handler) async {
        final requestOptions = e.requestOptions;

        print("error response:::: ${e.response?.data}");

        // If unauthorized, try refreshing token
        if (e.response?.statusCode == 401 &&
            !requestOptions.path.contains(ApiEndPoints.refreshToken)) {
          print("Hey123");
          final success = await _refreshAccessToken();

          if (success) {
            final newToken = await StorageHelper.getAccessToken();

            final opts = Options(
              method: requestOptions.method,
              headers: {
                ...requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
            );

            final cloneReq = await _dio!.request(
              requestOptions.path,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              options: opts,
            );

            return handler.resolve(cloneReq);
          } else {
            await StorageHelper.logout(); // Clear data on refresh failure
            e.response?.data = ApiResult.failure(
              error: 'Session expired. Please login again.',
              status: 401,
            );
          }
        }

        e.response?.data = ApiResult.failure(error: e.toString());
        return handler.next(e);
      },
    );
  }

  /// Calls the refresh token API and saves new tokens
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await StorageHelper.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio!.post(
        ApiEndPoints.refreshToken,
        data: {"refresh_token": refreshToken},
      );

      final result = response.data;

      if (response.statusCode == 200 && result["data"] != null) {
        // final newAccessToken = result["data"]["access_token"];
        // final newRefreshToken = result["data"]["refresh_token"];
        //
        // await StorageHelper.saveAccessToken(newAccessToken);
        // await StorageHelper.saveRefreshToken(newRefreshToken);
        return true;
      }
    } catch (e) {
      debugPrint("❌ Token refresh failed: $e");
    }
    return false;
  }

  void handleInvalidToken(Response response) async {
    if (response?.statusCode == 401) {
      print("Hey123");
      final success = await _refreshAccessToken();

      if (success) {
        final newToken = await StorageHelper.getAccessToken();

        final opts = Options(
          method: response.requestOptions.method,
          headers: {
            ...response.requestOptions.headers,
            'Authorization': 'Bearer $newToken',
          },
        );

        final cloneReq = await _dio!.request(
          response.requestOptions.path,
          data: response.requestOptions.data,
          queryParameters: response.requestOptions.queryParameters,
          options: opts,
        );
      } else {
        await StorageHelper.logout(); // Clear data on refresh failure
        response?.data = ApiResult.failure(
          error: 'Session expired. Please login again.',
          status: 401,
        );
      }
    }
  }
}
