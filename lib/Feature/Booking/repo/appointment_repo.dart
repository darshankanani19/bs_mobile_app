import '../models/appointment_request_model.dart';
import '../service/appointment_service.dart';

class AppointmentRepo {
  final AppointmentService service;

  AppointmentRepo(this.service);

  /// CREATE
  Future<void> createAppointment(AppointmentRequestModel payload) {
    return service.createAppointment(payload);
  }

  /// UPDATE
  Future<void> updateAppointment({
    required int appointmentId,
    required AppointmentRequestModel payload,
  }) {
    return service.updateAppointment(
      appointmentId: appointmentId,
      payload: payload,
    );
  }

  /// DELETE
  Future<void> deleteAppointment(int appointmentId) {
    return service.deleteAppointment(appointmentId);
  }
}
