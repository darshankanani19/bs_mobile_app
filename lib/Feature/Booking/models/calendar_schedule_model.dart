import 'package:intl/intl.dart';

class CalendarScheduleModel {
  final int id;
  final String clientName;
  final String description;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  CalendarScheduleModel({
    required this.id,
    required this.clientName,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory CalendarScheduleModel.fromJson(Map<String, dynamic> json) {
    final start = DateTime.parse(json['start_time']);
    final end = DateTime.parse(json['end_time']);

    return CalendarScheduleModel(
      id: json['id'],
      clientName: json['client_name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      startTime: start,
      endTime: end,
      durationMinutes: json['duration_minutes'] ?? 0,
    );
  }

  String get timeFrom => DateFormat.jm().format(startTime);
  String get timeTo => DateFormat.jm().format(endTime);
  DateTime get date => DateTime(startTime.year, startTime.month, startTime.day);
}
