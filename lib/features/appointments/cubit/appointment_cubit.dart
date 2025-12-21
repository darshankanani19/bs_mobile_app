import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_state.dart';
import 'package:beauty_salon/features/appointments/repo/appointment_repo.dart';
import 'package:beauty_salon/features/appointments/models/appointment_model.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepo repo;
  AppointmentCubit(this.repo) : super(const AppointmentState()) {
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    emit(state.copyWith(status: AppointmentStatus.loading));
    try {
      final services = await repo.getServices();
      final staff = await repo.getStaffMembers();
      emit(
        state.copyWith(
          status: AppointmentStatus.success,
          services: services,
          staffMembers: staff,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> createAppointment(AppointmentModel model) async {
    emit(state.copyWith(status: AppointmentStatus.loading));
    try {
      await repo.createAppointment(model);
      emit(state.copyWith(status: AppointmentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
