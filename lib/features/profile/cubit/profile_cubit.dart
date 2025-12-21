import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;

  ProfileCubit(this.repo) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileLoadStatus.loading));
    try {
      final profile = await repo.getProfile();
      emit(state.copyWith(status: ProfileLoadStatus.success, profile: profile));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileLoadStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileLoadStatus.loggingOut));
    await repo.logout();
    emit(state.copyWith(status: ProfileLoadStatus.loggedOut));
  }
}
