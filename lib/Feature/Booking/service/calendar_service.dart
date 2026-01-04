import 'package:bs/Core/Util/api_end_points.dart';
import 'package:bs/core/network/api_result.dart';
import 'package:bs/core/network/dio_client.dart';
import '../models/calendar_schedule_model.dart';
import 'package:intl/intl.dart';

class CalendarService {
  Future<List<CalendarScheduleModel>> fetchAppointments(DateTime date) async {
    final response = await DioClient().get(ApiEndPoints.appointments);

    if (response is ApiSuccess) {
      final List list = response.data;

      final targetDate = DateFormat('yyyy-MM-dd').format(date);

      return list
          .map((e) => CalendarScheduleModel.fromJson(e))
          .where(
            (e) => DateFormat('yyyy-MM-dd').format(e.startTime) == targetDate,
          )
          .toList();
    }

    throw Exception("Failed to fetch appointments");
  }
}
