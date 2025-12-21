import '../models/calendar_schedule_model.dart';
import '../service/calendar_service.dart';

class CalendarRepo {
  final CalendarService service;
  CalendarRepo(this.service);

  Future<List<CalendarScheduleModel>> getAppointments(DateTime date) {
    return service.fetchAppointments(date);
  }

  Future<void> updateStatus({
    required String bookingId,
    required String status,
  }) {
    return service.updateBookingStatus(bookingId: bookingId, status: status);
  }

  Future<void> deleteBooking(String bookingId) {
    return service.deleteBooking(bookingId);
  }
}
