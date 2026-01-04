import 'package:bs/Feature/home/models/home_schedule_model.dart';
import 'package:bs/Feature/home/service/home_service.dart';

class HomeRepo {
  final HomeService service;
  HomeRepo(this.service);

  Future<List<HomeScheduleModel>> getTodaySchedules() {
    return service.fetchTodaySchedules();
  }
}
