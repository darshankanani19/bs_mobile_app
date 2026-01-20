import 'package:bs/Core/Util/api_end_points.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/dio_client.dart';

import '../models/home_schedule_model.dart';

class HomeService {
  Future<List<HomeScheduleModel>> fetchTodaySchedules() async {
    final response = await DioClient().get(ApiEndPoints.appointments);
    final List data = response.data;
    return data.map((e) => HomeScheduleModel.fromJson(e)).toList();
  }
}
