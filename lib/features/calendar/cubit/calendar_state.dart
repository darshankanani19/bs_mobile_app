import 'package:beauty_salon/features/calendar/models/calendar_schedule_model.dart';

enum CalendarStatus { initial, loading, success, failure, updating, deleting }

class CalendarState {
  final CalendarStatus status;
  final DateTime selectedDate;
  final List<CalendarScheduleModel> appointments;
  final String? error;

  CalendarState({
    this.status = CalendarStatus.initial,
    DateTime? selectedDate,
    this.appointments = const [],
    this.error,
  }) : selectedDate = selectedDate ?? DateTime.now();

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? selectedDate,
    List<CalendarScheduleModel>? appointments,
    String? error,
  }) {
    return CalendarState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      error: error,
    );
  }
}
