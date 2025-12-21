import 'package:beauty_salon/features/home/models/home_schedule_model.dart';
import 'package:beauty_salon/features/home/service/home_service.dart';

class HomeRepo {
  final HomeService service;
  HomeRepo(this.service);

  Future<List<HomeScheduleModel>> getTodaySchedules() {
    return service.fetchTodaySchedules();
  }
}
