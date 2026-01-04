import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/appointment_repo.dart';
import '../models/appointment_request_model.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepo repo;

  AppointmentCubit(this.repo) : super(const AppointmentState());

  Future<void> createAppointment(AppointmentRequestModel payload) async {
    emit(state.copyWith(status: AppointmentStatus.loading));
    try {
      await repo.createAppointment(payload);
      emit(state.copyWith(status: AppointmentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: AppointmentStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> updateAppointment({
    required int appointmentId,
    required AppointmentRequestModel payload,
  }) async {
    emit(state.copyWith(status: AppointmentStatus.loading));
    try {
      await repo.updateAppointment(
        appointmentId: appointmentId,
        payload: payload,
      );
      emit(state.copyWith(status: AppointmentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: AppointmentStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    emit(state.copyWith(status: AppointmentStatus.loading));
    try {
      await repo.deleteAppointment(appointmentId);
      emit(state.copyWith(status: AppointmentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: AppointmentStatus.failure, error: e.toString()),
      );
    }
  }
}
