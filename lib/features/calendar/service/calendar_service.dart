import 'package:beauty_salon/core/network/api_result.dart';
import 'package:beauty_salon/core/network/dio_client.dart';
import 'package:beauty_salon/core/utils/api_end_points.dart';
import 'package:beauty_salon/features/authentication/cubit/authentication_cubit.dart';
import 'package:beauty_salon/features/authentication/repo/authentication_repo.dart';
import '../models/calendar_schedule_model.dart';
import 'package:intl/intl.dart';

class CalendarService {
  /// Fetch appointments by date
  Future<List<CalendarScheduleModel>> fetchAppointments(DateTime date) async {
    final response = await DioClient().get(ApiEndPoints.getbooking);

    if (response is ApiSuccess) {
      final List data = response.data;
      final selectedDate = DateFormat('yyyy-MM-dd').format(date);

      return data
          .map((e) => CalendarScheduleModel.fromJson(e))
          .where((e) => DateFormat('yyyy-MM-dd').format(e.date) == selectedDate)
          .toList();
    }

    throw Exception("Unexpected response");
  }

  /// ✅ UPDATE STATUS (updated_by = null)
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    final response = await DioClient().put(
      '${ApiEndPoints.Booking}/$bookingId',
      data: {
        "status": status.toString(),
        "updated_by": "24",
        "reason": "update", // ✅ THIS FIXES SERVER CRASH
      },
    );

    if (response is! ApiSuccess) {
      throw Exception("Failed to update booking");
    }
    throw Exception("update successfully");
  }

  /// DELETE BOOKING
  Future<void> deleteBooking(String bookingId) async {
    final response = await DioClient().delete(
      '${ApiEndPoints.Booking}/$bookingId',
      queryParameters: {"updated_by": "system"},
    );

    if (response is! ApiSuccess) {
      throw Exception("Failed to delete booking");
    }
  }
}
