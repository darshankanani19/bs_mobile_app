import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../models/appointment_request_model.dart';
import '../repo/appointment_repo.dart';
import 'package:bs/core/network/api_result_service.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepo appointmentRepo;

  AppointmentCubit({required this.appointmentRepo})
    : super(const AppointmentState());

  /// ================= CREATE =================
  Future<void> create(AppointmentRequestModel payload) async {
    try {
      emit(
        state.copyWith(
          createStatus: FormzSubmissionStatus.inProgress,
          errorMessage: null,
        ),
      );

      debugPrint('📤 Create Appointment Payload: ${payload.toJson()}');

      final RepoResult response = await appointmentRepo.createAppointment(
        payload,
      );

      if (response is RepoSuccess) {
        debugPrint('✅ Create Appointment Success: ${response.data}');
        emit(state.copyWith(createStatus: FormzSubmissionStatus.success));
      } else if (response is RepoFailure) {
        debugPrint('❌ Create Appointment Failed: ${response.error}');
        emit(
          state.copyWith(
            createStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Create Appointment Exception: $e');
      emit(
        state.copyWith(
          createStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// ================= UPDATE =================
  Future<void> update(int id, AppointmentRequestModel payload) async {
    try {
      emit(
        state.copyWith(
          updateStatus: FormzSubmissionStatus.inProgress,
          errorMessage: null,
        ),
      );

      debugPrint(
        '📤 Update Appointment ID: $id | Payload: ${payload.toJson()}',
      );

      final RepoResult response = await appointmentRepo.updateAppointment(
        id,
        payload,
      );

      if (response is RepoSuccess) {
        debugPrint('✅ Update Appointment Success: ${response.data}');
        emit(state.copyWith(updateStatus: FormzSubmissionStatus.success));
      } else if (response is RepoFailure) {
        debugPrint('❌ Update Appointment Failed: ${response.error}');
        emit(
          state.copyWith(
            updateStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Update Appointment Exception: $e');
      emit(
        state.copyWith(
          updateStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// ================= DELETE =================
  Future<void> delete(int id) async {
    try {
      emit(
        state.copyWith(
          deleteStatus: FormzSubmissionStatus.inProgress,
          errorMessage: null,
        ),
      );

      debugPrint('🗑 Delete Appointment ID: $id');

      final RepoResult response = await appointmentRepo.deleteAppointment(id);

      if (response is RepoSuccess) {
        debugPrint('✅ Delete Appointment Success');
        emit(state.copyWith(deleteStatus: FormzSubmissionStatus.success));
      } else if (response is RepoFailure) {
        debugPrint('❌ Delete Appointment Failed: ${response.error}');
        emit(
          state.copyWith(
            deleteStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Delete Appointment Exception: $e');
      emit(
        state.copyWith(
          deleteStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetState() {
    emit(const AppointmentState());
  }
}
