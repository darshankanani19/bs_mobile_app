import '../models/home_schedule_model.dart';

enum HomeLoadStatus { initial, loading, success, failure }

class HomeState {
  final HomeLoadStatus status;
  final List<HomeScheduleModel> schedules;
  final int total;
  final int completed;
  final int pending;
  final String? error;

  const HomeState({
    this.status = HomeLoadStatus.initial,
    this.schedules = const [],
    this.total = 0,
    this.completed = 0,
    this.pending = 0,
    this.error,
  });

  HomeState copyWith({
    HomeLoadStatus? status,
    List<HomeScheduleModel>? schedules,
    int? total,
    int? completed,
    int? pending,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      total: total ?? this.total,
      completed: completed ?? this.completed,
      pending: pending ?? this.pending,
      error: error,
    );
  }
}
