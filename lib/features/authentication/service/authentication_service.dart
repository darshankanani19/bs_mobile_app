import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:beauty_salon/core/network/api_result.dart';
import 'package:beauty_salon/core/network/dio_client.dart';
import 'package:beauty_salon/core/utils/api_end_points.dart';

class AuthenticationService {
  Future<ApiResult> signup(Map<String, dynamic> payload) async {
    ApiResult apiResult = await DioClient().post(
      ApiEndPoints.signup,
      data: payload,
    );
    return apiResult;
  }

  Future<ApiResult> login(Map<String, dynamic> payload) async {
    try {
      final apiResult = await DioClient().post(
        ApiEndPoints.login,
        data: payload,
      );
      return apiResult;
    } catch (e) {
      // ✅ Print error in console
      debugPrint('❌ Login error: $e');
      return ApiResult.failure(
        error: e.toString(),
        status: 500,
      ); // handle gracefully
    }
  }

  Future<ApiResult> forgotPassword(Map<String, dynamic> payload) async {
    return await DioClient().post(ApiEndPoints.forgotPassword, data: payload);
  }

  Future<ApiResult> resetPassword({
    required Map<String, dynamic> payload,
  }) async {
    return await DioClient().post(ApiEndPoints.resetPassword, data: payload);
  }

  Future<ApiResult> getUser() async {
    final response = await DioClient().get(ApiEndPoints.getuser);
    return response;
  }

  Future<ApiResult> logout() async {
    final response = await DioClient().post(ApiEndPoints.logout);
    return response;
  }
}
