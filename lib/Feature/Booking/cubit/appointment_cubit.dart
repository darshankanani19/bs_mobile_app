import 'package:bs/Feature/Booking/cubit/appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs/Feature/Booking/repo/appointment_repo.dart';
import 'package:bs/Feature/Booking/models/appointment_request_model.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepo repo;

  AppointmentCubit(this.repo) : super(const AppointmentState());

  void createAppointment(AppointmentRequestModel payload) async {
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

  void updateAppointment({
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

  void deleteAppointment(int appointmentId) async {
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
