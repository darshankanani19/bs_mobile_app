import 'package:bs/Core/Network/api_result.dart';
import 'package:bs/Core/Network/dio_client.dart';
import 'package:bs/Core/Util/api_end_points.dart';
import 'package:bs/Feature/home/models/home_schedule_model.dart';

class HomeService {
  Future<List<HomeScheduleModel>> fetchTodaySchedules() async {
    final response = await DioClient().get(ApiEndPoints.appointments);

    if (response is ApiSuccess) {
      final List data = response.data;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return data.map((e) => HomeScheduleModel.fromJson(e)).where((e) {
        final d = DateTime(
          e.startTime.year,
          e.startTime.month,
          e.startTime.day,
        );
        return d == today;
      }).toList();
    }

    throw Exception("Failed to fetch schedules");
  }
}
