// To parse this JSON data, do
//
//     final forgotPasswordRequestModel = forgotPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordRequestModel forgotPasswordRequestModelFromJson(String str) => ForgotPasswordRequestModel.fromJson(json.decode(str));

String forgotPasswordRequestModelToJson(ForgotPasswordRequestModel data) => json.encode(data.toJson());

class ForgotPasswordRequestModel {
  String email;

  ForgotPasswordRequestModel({
    required this.email,
  });

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ForgotPasswordRequestModel(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
