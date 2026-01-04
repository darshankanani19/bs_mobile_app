import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<ProfileModel> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return ProfileModel(
      salonName: 'Luxe & Co. Salon',
      ownerName: 'Jane Doe, Owner',
      imageUrl: '',
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clears token + user data
  }
}
