class AppointmentModel {
  final String clientId;
  final String service;
  final String staffMember;
  final DateTime dateTime;
  final String notes;

  AppointmentModel({
    required this.clientId,
    required this.service,
    required this.staffMember,
    required this.dateTime,
    this.notes = '',
  });

  /// ✅ Convert model to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'service': service,
      'staffMember': staffMember,
      'dateTime': dateTime.toIso8601String(), // store in ISO format
      'notes': notes,
    };
  }

  /// ✅ Create model from JSON (for responses from server)
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      clientId: json['clientId'] ?? '',
      service: json['service'] ?? '',
      staffMember: json['staffMember'] ?? '',
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      notes: json['notes'] ?? '',
    );
  }

  /// ✅ Optional: for convenience when decoding lists
  static List<AppointmentModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  /// ✅ CopyWith for immutability and BLoC usage
  AppointmentModel copyWith({
    String? clientId,
    String? service,
    String? staffMember,
    DateTime? dateTime,
    String? notes,
  }) {
    return AppointmentModel(
      clientId: clientId ?? this.clientId,
      service: service ?? this.service,
      staffMember: staffMember ?? this.staffMember,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(clientId: $clientId, service: $service, staffMember: $staffMember, dateTime: $dateTime, notes: $notes)';
  }
}
