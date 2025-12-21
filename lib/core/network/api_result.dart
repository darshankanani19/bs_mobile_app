import 'package:beauty_salon/core/network/api_result_service.dart';

abstract class ApiResult<T> extends Result<T> {
  const ApiResult._() : super.empty();
  const factory ApiResult.success({T data, int? status}) = ApiSuccess<T>;
  const factory ApiResult.failure({required String error, int? status}) =
      ApiFailure<T>;
}

class ApiSuccess<T> extends ApiResult<T> {
  final T? data;
  final int? status;
  const ApiSuccess({this.data, this.status}) : super._();

  @override
  String toString() => 'ApiSuccess(data: $data, status: $status)';
}

class ApiFailure<T> extends ApiResult<T> {
  final String error;
  final int? status;
  const ApiFailure({required this.error, this.status}) : super._();

  @override
  String toString() => 'ApiFailure(error: $error, status: $status)';
}

Future<ApiResult> commonApiCall(Future<ApiResult<dynamic>> apiCall) async {
  try {
    return await apiCall;
  } catch (e) {
    return ApiResult.failure(error: e.toString());
  }
}
