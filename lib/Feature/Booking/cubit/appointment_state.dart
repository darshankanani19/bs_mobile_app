enum AppointmentStatus { initial, loading, success, failure }

class AppointmentState {
  final AppointmentStatus status;
  final String? error;

  const AppointmentState({this.status = AppointmentStatus.initial, this.error});

  AppointmentState copyWith({AppointmentStatus? status, String? error}) {
    return AppointmentState(status: status ?? this.status, error: error);
  }
}
