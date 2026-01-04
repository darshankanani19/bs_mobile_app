import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/calendar_repo.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepo repo;

  CalendarCubit(this.repo)
    : super(CalendarState(selectedDate: DateTime.now())) {
    loadAppointments(DateTime.now()); // auto-load today
  }

  void selectDate(DateTime date) {
    loadAppointments(date);
  }

  Future<void> loadAppointments(DateTime date) async {
    emit(state.copyWith(status: CalendarStatus.loading, selectedDate: date));

    try {
      final data = await repo.fetchAppointments(date);
      emit(state.copyWith(status: CalendarStatus.success, appointments: data));
    } catch (e) {
      emit(
        state.copyWith(
          status: CalendarStatus.failure,
          appointments: [],
          error: e.toString(),
        ),
      );
    }
  }

  /// Call this after CREATE / UPDATE / DELETE
  void refresh() {
    loadAppointments(state.selectedDate);
  }
}
