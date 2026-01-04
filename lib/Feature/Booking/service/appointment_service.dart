import 'package:bs/Core/Util/api_end_points.dart';
import 'package:bs/core/network/dio_client.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/Feature/Booking/models/appointment_request_model.dart';

class AppointmentService {
  /// CREATE
  Future<void> createAppointment(AppointmentRequestModel payload) async {
    final response = await DioClient().post(
      ApiEndPoints.appointments,
      data: payload.toJson(),
    );

    if (response is ApiSuccess) return;
    throw Exception("Failed to create appointment");
  }

  /// UPDATE
  Future<void> updateAppointment({
    required int appointmentId,
    required AppointmentRequestModel payload,
  }) async {
    final response = await DioClient().put(
      ApiEndPoints.appointmentById(appointmentId),
      data: payload.toJson(),
    );

    if (response is ApiSuccess) return;
    throw Exception("Failed to update appointment");
  }

  /// DELETE  ✅ FIXED (204 SUPPORT)
  Future<void> deleteAppointment(int appointmentId) async {
    final response = await DioClient().delete(
      ApiEndPoints.appointmentById(appointmentId),
    );

    /// 204 → success → no body
    if (response == null || response is ApiSuccess) return;

    throw Exception("Failed to delete appointment");
  }
}
