import 'package:equatable/equatable.dart';
import '../models/home_schedule_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<HomeScheduleModel> schedules;
  final int total;
  final int completed;
  final int pending;
  final String? error;

  const HomeState({
    this.status = HomeStatus.initial,
    this.schedules = const [],
    this.total = 0,
    this.completed = 0,
    this.pending = 0,
    this.error,
  });

  HomeState copyWith({
    HomeStatus? status,
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

  @override
  List<Object?> get props =>
      [status, schedules, total, completed, pending, error];
}
