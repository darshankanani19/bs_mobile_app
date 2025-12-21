import 'package:beauty_salon/core/network/api_result.dart';
import 'package:intl/intl.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/api_end_points.dart';
import '../models/home_schedule_model.dart';

class HomeService {
  Future<List<HomeScheduleModel>> fetchTodaySchedules() async {
    final response = await DioClient().get(ApiEndPoints.getbooking);

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
