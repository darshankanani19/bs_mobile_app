import 'package:intl/intl.dart';

enum AppointmentStatus { pending, completed, scheduled }

class HomeScheduleModel {
  final int id;
  final String name;
  final String service;
  final String timeText;
  final AppointmentStatus status;
  final DateTime startTime;

  HomeScheduleModel({
    required this.id,
    required this.name,
    required this.service,
    required this.timeText,
    required this.status,
    required this.startTime,
  });

  factory HomeScheduleModel.fromJson(Map<String, dynamic> json) {
    final startUtc = DateTime.parse(json['start_time']);
    final startLocal = startUtc.toLocal(); // ✅ VERY IMPORTANT

    return HomeScheduleModel(
      id: json['id'],
      name: json['client_name'] ?? 'Unknown',
      service: json['description'] ?? '',
      timeText: DateFormat.jm().format(startLocal),
      status: _mapStatus(json['status']),
      startTime: startLocal, // ✅ store local time
    );
  }

  static AppointmentStatus _mapStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'scheduled':
        return AppointmentStatus.pending;
      default:
        return AppointmentStatus.pending;
    }
  }
}
