import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/api_result_service.dart';

import '../models/appointment_request_model.dart';
import '../service/appointment_service.dart';

class AppointmentRepo {
  final service = AppointmentService();

  Future<RepoResult> createAppointment(AppointmentRequestModel payload) async {
    try {
      final ApiResult result = await service.create(payload);

      if (result is ApiSuccess) {
        return RepoResult.success(data: result.data);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult> updateAppointment(
    int id,
    AppointmentRequestModel payload,
  ) async {
    try {
      final ApiResult result = await service.update(id, payload);

      if (result is ApiSuccess) {
        return RepoResult.success(data: result.data);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }

  Future<RepoResult> deleteAppointment(int id) async {
    try {
      final ApiResult result = await service.delete(id);

      if (result is ApiSuccess) {
        return RepoResult.success(data: null);
      } else {
        return RepoResult.failure(error: (result as ApiFailure).error);
      }
    } catch (e) {
      return RepoResult.failure(error: e.toString());
    }
  }
}
