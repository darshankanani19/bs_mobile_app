import 'package:intl/intl.dart';

enum AppointmentStatus { pending, completed }

class HomeScheduleModel {
  final String id;
  final String name;
  final String service;
  final String timeText;
  final AppointmentStatus status;
  final DateTime date;

  HomeScheduleModel({
    required this.id,
    required this.name,
    required this.service,
    required this.timeText,
    required this.status,
    required this.date,
  });

  factory HomeScheduleModel.fromJson(Map<String, dynamic> json) {
    final time = DateTime.parse("2025-01-01 ${json['time']}");

    return HomeScheduleModel(
      id: json['id'].toString(),
      name: "User #${json['user_id']}",
      service: json['description'] ?? '',
      timeText: DateFormat.jm().format(time),
      status: (json['status'] as String).toLowerCase() == 'completed'
          ? AppointmentStatus.completed
          : AppointmentStatus.pending,
      date: DateTime.parse(json['date']),
    );
  }
}
