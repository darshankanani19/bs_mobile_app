// To parse this JSON data, do
//
//     final resetPasswordResponseModel = resetPasswordResponseModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordResponseModel resetPasswordResponseModelFromJson(String str) => ResetPasswordResponseModel.fromJson(json.decode(str));

String resetPasswordResponseModelToJson(ResetPasswordResponseModel data) => json.encode(data.toJson());

class ResetPasswordResponseModel {
  DateTime timestamp;
  int status;
  String message;
  dynamic data;

  ResetPasswordResponseModel({
    required this.timestamp,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) => ResetPasswordResponseModel(
    timestamp: DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "status": status,
    "message": message,
    "data": data,
  };
}
