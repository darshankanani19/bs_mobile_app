import '../models/calendar_schedule_model.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState {
  final CalendarStatus status;
  final DateTime selectedDate;
  final List<CalendarScheduleModel> appointments;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    this.status = CalendarStatus.initial,
    this.appointments = const [],
    this.error,
  });

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
