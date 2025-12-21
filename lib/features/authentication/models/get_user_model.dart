// To parse this JSON data, do
//
//     final getusermodel = getusermodelFromJson(jsonString);

import 'dart:convert';

Getusermodel getusermodelFromJson(String str) => Getusermodel.fromJson(json.decode(str));

String getusermodelToJson(Getusermodel data) => json.encode(data.toJson());

class Getusermodel {
  DateTime timestamp;
  int status;
  String message;
  Data data;

  Getusermodel({
    required this.timestamp,
    required this.status,
    required this.message,
    required this.data,
  });

  factory Getusermodel.fromJson(Map<String, dynamic> json) => Getusermodel(
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String name;
  String email;
  String phone;
  String userType;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "user_type": userType,
  };
}
