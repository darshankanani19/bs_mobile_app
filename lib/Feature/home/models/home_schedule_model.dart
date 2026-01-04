import 'package:intl/intl.dart';

enum AppointmentStatus { scheduled, pending, completed, cancelled }

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
    final utcStart = DateTime.parse(json['start_time']);
    final localStart = utcStart.toLocal();

    return HomeScheduleModel(
      id: json['id'],
      name: json['client_name'] ?? '',
      service: json['description'] ?? '',
      timeText: DateFormat.jm().format(localStart),
      status: _parseStatus(json['status']),
      startTime: localStart,
    );
  }

  static AppointmentStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'pending':
      default:
        return AppointmentStatus.pending;
    }
  }
}
