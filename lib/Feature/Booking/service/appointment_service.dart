import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/dio_client.dart';
import 'package:bs/Core/Util/api_end_points.dart';

import '../models/appointment_request_model.dart';

class AppointmentService {
  Future<ApiResult> create(AppointmentRequestModel payload) async {
    final ApiResult result = await DioClient().post(
      ApiEndPoints.appointments,
      data: payload.toJson(),
    );
    return result;
  }

  Future<ApiResult> update(int id, AppointmentRequestModel payload) async {
    final ApiResult result = await DioClient().put(
      ApiEndPoints.appointmentById(id),
      data: payload.toJson(),
    );
    return result;
  }

  Future<ApiResult> delete(int id) async {
    final ApiResult result = await DioClient().delete(
      ApiEndPoints.appointmentById(id),
    );
    return result;
  }
}
