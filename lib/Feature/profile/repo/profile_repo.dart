import 'package:bs/Feature/profile/models/profile_model.dart';
import 'package:bs/Feature/profile/services/profile_service.dart';

class ProfileRepo {
  final ProfileService service;

  ProfileRepo(this.service);

  Future<ProfileModel> getProfile() {
    return service.fetchProfile();
  }

  Future<void> logout() {
    return service.logout();
  }
}
