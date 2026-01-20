import 'package:bs/Core/Util/api_end_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/dio_client.dart';

class AuthenticationService {
  Future<ApiResult> signup(Map<String, dynamic> payload) async {
    ApiResult apiResult = await DioClient().post(
      ApiEndPoints.signup,
      data: payload,
    );
    return apiResult;
  }

  Future<ApiResult> login(Map<String, dynamic> payload) async {
    final response = await DioClient().post(ApiEndPoints.login, data: payload);
    return ApiResult.success(data: response.data);
  }

  Future<ApiResult> forgotPassword(Map<String, dynamic> payload) async {
    return await DioClient().post(ApiEndPoints.forgotPassword, data: payload);
  }

  Future<ApiResult> resetPassword({
    required Map<String, dynamic> payload,
  }) async {
    return await DioClient().post(ApiEndPoints.resetPassword, data: payload);
  }

  Future<ApiResult> logout() async {
    final response = await DioClient().post(ApiEndPoints.logout);
    return ApiResult.success(data: response.data);
  }
}
