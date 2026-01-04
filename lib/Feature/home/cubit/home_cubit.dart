import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/home_repo.dart';
import 'home_state.dart';
import '../models/home_schedule_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;
  HomeCubit(this.repo) : super(const HomeState());

  Future<void> load() async {
    emit(state.copyWith(status: HomeLoadStatus.loading));

    try {
      final future = repo.getTodaySchedules();

      final list = await future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => <HomeScheduleModel>[],
      );

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
