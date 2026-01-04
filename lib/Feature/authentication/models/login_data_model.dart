// class LoginResponse {
//   final String? timestamp;
//   final int? status;
//   final String? message;
//   final LoginData? data;
//
//   LoginResponse({
//     this.timestamp,
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
//     timestamp: json["timestamp"],
//     status: json["status"],
//     message: json["message"],
//     data: json["data"] != null ? LoginData.fromMap(json["data"]) : null,
//   );
//
//   Map<String, dynamic> toMap() => {
//     "timestamp": timestamp,
//     "status": status,
//     "message": message,
//     "data": data?.toMap(),
//   };
// }
//
// class LoginData {
//   final String? token;
//   final String? message;
//
//   LoginData({
//     this.token,
//     this.message,
//   });
//
//   factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
//     token: json["token"],
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "token": token,
//     "message": message,
//   };
// }
class LoginResponse {
  final String? timestamp;
  final int? status;
  final String? message;
  final LoginData? data;

  LoginResponse({this.timestamp, this.status, this.message, this.data});

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    timestamp: json["timestamp"],
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? LoginData.fromMap(json["data"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "timestamp": timestamp,
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}

class LoginData {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;

  LoginData({this.accessToken, this.refreshToken, this.tokenType});

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "token_type": tokenType,
  };
}
