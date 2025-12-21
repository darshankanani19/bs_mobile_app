// To parse this JSON data, do
//
//     final resetPasswordRequestModel = resetPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequestModel resetPasswordRequestModelFromJson(String str) => ResetPasswordRequestModel.fromJson(json.decode(str));

String resetPasswordRequestModelToJson(ResetPasswordRequestModel data) => json.encode(data.toJson());

class ResetPasswordRequestModel {
  String email;
  String newPassword;
  String otp;

  ResetPasswordRequestModel({
    required this.email,
    required this.newPassword,
    required this.otp,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) => ResetPasswordRequestModel(
    email: json["email"],
    newPassword: json["new_password"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "new_password": newPassword,
    "otp": otp,
  };
}
