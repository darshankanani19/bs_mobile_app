import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs/Feature/home/repo/home_repo.dart';
import 'home_state.dart';
import 'package:bs/Feature/home/models/home_schedule_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit(this.repo) : super(const HomeState()) {
    load(); // auto load today
  }

  Future<void> load() async {
    emit(state.copyWith(status: HomeLoadStatus.loading));

    try {
      final list = await repo.getTodaySchedules();

      final completed = list
          .where((e) => e.status == AppointmentStatus.completed)
          .length;
      final pending = list
          .where((e) => e.status == AppointmentStatus.pending)
          .length;

      emit(
        state.copyWith(
          status: HomeLoadStatus.success,
          schedules: list,
          total: list.length,
          completed: completed,
          pending: pending,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeLoadStatus.failure, error: e.toString()));
    }
  }
}
