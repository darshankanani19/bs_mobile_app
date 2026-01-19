import '../models/home_schedule_model.dart';
import '../service/home_service.dart';

class HomeRepo {
  final service = HomeService();
  HomeRepo();

  Future<List<HomeScheduleModel>> getTodaySchedules() {
    return service.fetchTodaySchedules();
  }
}
