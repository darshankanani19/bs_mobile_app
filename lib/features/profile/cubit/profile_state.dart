import '../models/profile_model.dart';

enum ProfileLoadStatus {
  initial,
  loading,
  success,
  failure,
  loggingOut,
  loggedOut,
}

class ProfileState {
  final ProfileLoadStatus status;
  final ProfileModel? profile;
  final String? error;

  const ProfileState({
    this.status = ProfileLoadStatus.initial,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    ProfileLoadStatus? status,
    ProfileModel? profile,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}
