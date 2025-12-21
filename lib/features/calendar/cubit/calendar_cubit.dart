import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/calendar_repo.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepo repo;

  CalendarCubit(this.repo) : super(CalendarState());

  Future<void> loadAppointments(DateTime date) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    try {
      final list = await repo.getAppointments(date);
      emit(
        state.copyWith(
          status: CalendarStatus.success,
          selectedDate: date,
          appointments: list,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, error: e.toString()));
    }
  }

  void selectDate(DateTime date) {
    loadAppointments(date);
  }

  Future<void> updateBooking({
    required String bookingId,
    required String status,
  }) async {
    try {
      await repo.updateStatus(bookingId: bookingId, status: status);
      await loadAppointments(state.selectedDate);
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, error: e.toString()));
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await repo.deleteBooking(bookingId);
      await loadAppointments(state.selectedDate);
    } catch (e) {
      emit(state.copyWith(status: CalendarStatus.failure, error: e.toString()));
    }
  }
}
