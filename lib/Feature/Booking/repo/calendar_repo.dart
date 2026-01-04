import '../models/calendar_schedule_model.dart';
import '../service/calendar_service.dart';

class CalendarRepo {
  final CalendarService service;

  CalendarRepo(this.service);

  Future<List<CalendarScheduleModel>> fetchAppointments(DateTime date) {
    return service.fetchAppointments(date);
  }
}
