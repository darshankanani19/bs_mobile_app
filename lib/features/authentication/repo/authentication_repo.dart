import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:beauty_salon/core/network/api_result.dart';
import 'package:beauty_salon/core/network/api_result_service.dart';
import 'package:beauty_salon/features/authentication/models/forgot_password_request_model.dart';
import 'package:beauty_salon/features/authentication/models/forgot_password_response_model.dart';
import 'package:beauty_salon/features/authentication/models/get_user_model.dart';
import 'package:beauty_salon/features/authentication/models/login_data_model.dart';
import 'package:beauty_salon/features/authentication/service/authentication_service.dart';

class AuthenticationRepo {
  final authenticationService = AuthenticationService();
  Future<RepoResult> signup({required Map<String, dynamic> payload}) async {
    try {
      final result = await authenticationService.signup(payload);

      if (result is ApiSuccess) {
        print("✅ Signup Repo Success Data: ${result.data}");
        return RepoResult.success(data: result.data);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult<LoginResponse>> login({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await commonApiCall(
        authenticationService.login(payload),
      );

      if (response is ApiSuccess) {
        // Response shapes vary between environments/APIs.
        // Handle common shapes:
        // 1) Wrapped: { timestamp, status, message, data: { access_token, refresh_token } }
        // 2) Flat tokens: { access: "...", refresh: "..." }
        // 3) Flat tokens with different keys: { access_token: "...", refresh_token: "..." }

        final Map<String, dynamic> map = Map<String, dynamic>.from(response.data ?? {});

        LoginResponse loginResponse;

        if (map.containsKey('data') && map['data'] is Map) {
          // Preferred wrapped format
          loginResponse = LoginResponse.fromMap(map);
        } else if (map.containsKey('access') || map.containsKey('refresh')) {
          // Flat tokens with keys 'access'/'refresh'
          final access = map['access']?.toString();
          final refresh = map['refresh']?.toString();
          final tokenType = map['token_type']?.toString() ?? map['type']?.toString();

          loginResponse = LoginResponse(
            timestamp: map['timestamp']?.toString(),
            status: map['status'] is int ? map['status'] as int : null,
            message: map['message']?.toString(),
            data: LoginData(
              accessToken: access,
              refreshToken: refresh,
              tokenType: tokenType,
            ),
          );
        } else if (map.containsKey('access_token') || map.containsKey('refresh_token')) {
          // Flat tokens with underscore keys
          final access = map['access_token']?.toString();
          final refresh = map['refresh_token']?.toString();
          final tokenType = map['token_type']?.toString();

          loginResponse = LoginResponse(
            timestamp: map['timestamp']?.toString(),
            status: map['status'] is int ? map['status'] as int : null,
            message: map['message']?.toString(),
            data: LoginData(
              accessToken: access,
              refreshToken: refresh,
              tokenType: tokenType,
            ),
          );
        } else {
          // Fallback: try to parse entire response as LoginResponse
          try {
            loginResponse = LoginResponse.fromMap(map);
          } catch (_) {
            // If parsing failed, return failure
            return RepoResult.failure(
              error: 'Unexpected login response format',
            );
          }
        }

        return RepoResult.success(
          data: loginResponse,
          successCode: response.status,
        );
      } else {
        return RepoResult.failure(
          error: (response as ApiFailure).error,
          errorCode: response.status,
        );
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult<ForgotPasswordResponseModel>> forgotPassword({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await authenticationService.forgotPassword(payload);

      if (response is ApiSuccess) {
        final parsed = ForgotPasswordResponseModel.fromJson(response.data);
        return RepoResult.success(data: parsed);
      } else {
        return RepoResult.failure(error: (response as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult> resetPassword({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await authenticationService.resetPassword(
        payload: payload,
      );

      if (response is ApiSuccess) {
        return RepoResult.success(data: response.data);
      } else {
        return RepoResult.failure(error: (response as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult<Getusermodel>> getUser() async {
    try {
      final result = await authenticationService.getUser();

      if (result is ApiSuccess) {
        final model = Getusermodel.fromJson(result.data);
        return RepoResult.success(data: model);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult> logout() async {
    try {
      final result = await authenticationService.logout();
      if (result is ApiSuccess) {
        return RepoResult.success(data: result.data);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }
}
