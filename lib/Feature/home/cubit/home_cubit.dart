import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../repo/home_repo.dart';
import '../models/home_schedule_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit(this.repo) : super(const HomeState());

  Future<void> load() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      debugPrint('📥 HOME: Fetching today appointments');

      final all = await repo.getTodaySchedules();

      // 🔥 FILTER ONLY TODAY
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final todayList = all.where((e) {
        final d = DateTime(
          e.startTime.year,
          e.startTime.month,
          e.startTime.day,
        );
        return d == today;
      }).toList();

      final completed = todayList
          .where((e) => e.status == AppointmentStatus.completed)
          .length;

      final pending = todayList.length - completed;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          schedules: todayList,
          total: todayList.length,
          completed: completed,
          pending: pending,
        ),
      );
    } catch (e) {
      debugPrint('❌ HOME ERROR: $e');
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  /// 🔄 Call after create / update / delete
  Future<void> reload() async {
    debugPrint('🔄 HOME: Reload triggered');
    await load();
  }
}
