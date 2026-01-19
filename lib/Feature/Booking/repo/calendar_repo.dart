import 'package:bs/Feature/Booking/models/calendar_schedule_model.dart';
import 'package:bs/Feature/Booking/service/calendar_service.dart';

class CalendarRepo {
  final service = CalendarService();

  Future<List<CalendarScheduleModel>> fetchAppointments(DateTime date) {
    return service.fetchAppointments(date);
  }
}
