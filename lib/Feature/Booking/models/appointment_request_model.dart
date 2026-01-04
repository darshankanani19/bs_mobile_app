class AppointmentRequestModel {
  final String client_name;
  final String start_time;
  final int duration_minutes;
  final String description;
  final String status;

  AppointmentRequestModel({
    required this.client_name,
    required this.start_time,
    required this.duration_minutes,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "client_name": client_name,
      "start_time": start_time,
      "duration_minutes": duration_minutes,
      "description": description,
      "status": status,
    };
  }
}
