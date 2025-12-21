// lib/features/calendar/models/calendar_schedule_model.dart
import 'package:intl/intl.dart';

class CalendarScheduleModel {
  final String id;
  final String clientName;
  final String service;
  final String staffName;
  final String timeFrom;
  final String timeTo;
  final DateTime date;

  CalendarScheduleModel({
    required this.id,
    required this.clientName,
    required this.service,
    required this.staffName,
    required this.timeFrom,
    required this.timeTo,
    required this.date,
  });

  factory CalendarScheduleModel.fromJson(Map<String, dynamic> json) {
    // API time: "11:09:52"
    final start = DateTime.parse("2025-01-01 ${json['time']}");

    return CalendarScheduleModel(
      id: json['id'].toString(),

      // You don’t have name in API yet
      clientName: "User #${json['user_id']}",

      service: json['description'] ?? '',

      staffName: "Therapist #${json['therapist_id']}",

      timeFrom: DateFormat.jm().format(start),

      // assuming 45 min service
      timeTo: DateFormat.jm().format(start.add(const Duration(minutes: 45))),

      date: DateTime.parse(json['date']),
    );
  }
}
