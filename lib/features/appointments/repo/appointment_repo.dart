import 'package:beauty_salon/features/appointments/service/appointment_service.dart';
import 'package:beauty_salon/features/appointments/models/appointment_model.dart';

class AppointmentRepo {
  final AppointmentService service;
  AppointmentRepo(this.service);

  Future<List<String>> getServices() async => await service.fetchServices();
  Future<List<String>> getStaffMembers() async =>
      await service.fetchStaffMembers();

  Future<void> createAppointment(AppointmentModel model) async {
    await service.createAppointment(model.toJson());
  }
}
