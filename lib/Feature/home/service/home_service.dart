import 'package:bs/Core/Util/api_end_points.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/dio_client.dart';
import 'package:bs/Feature/home/models/home_schedule_model.dart';

class HomeService {
  Future<List<HomeScheduleModel>> fetchTodaySchedules() async {
    final response = await DioClient().get(ApiEndPoints.appointment);

    if (response is ApiSuccess) {
      final List data = response.data;
      final today = DateTime.now();

      return data
          .map((e) => HomeScheduleModel.fromJson(e))
          .where(
            (e) =>
                e.date.year == today.year &&
                e.date.month == today.month &&
                e.date.day == today.day,
          )
          .toList();
    }

    throw Exception("Unexpected response");
  }
}
