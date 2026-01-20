import 'dart:async';

import 'package:bs/Feature/authentication/service/authentication_service.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/api_result_service.dart';
import 'package:bs/Feature/authentication/models/forgot_password_response_model.dart';
import 'package:bs/Feature/authentication/models/login_data_model.dart';

import 'package:bs/Core/helper/storage_helper.dart';

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
      final response = await authenticationService.login(payload);

      if (response is ApiSuccess) {
        final data = Map<String, dynamic>.from(response.data);

        // ✅ Extract JWT tokens
        final access = data['access'];
        final refresh = data['refresh'];

        // ✅ Save tokens for interceptor
        await StorageHelper.saveAccessToken(access);
        await StorageHelper.saveRefreshToken(refresh);

        // Optional: wrap into model if needed
        final loginResponse = LoginResponse(
          data: LoginData(accessToken: access, refreshToken: refresh),
        );

        return RepoResult.success(data: loginResponse);
      } else {
        return RepoResult.failure(error: (response as ApiFailure).error);
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
