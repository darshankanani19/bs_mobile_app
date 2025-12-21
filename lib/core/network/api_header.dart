import 'package:beauty_salon/core/helper/storage_helper.dart';

class ApiHeaders {
  static Future<Map<String, dynamic>> getHeaders({String? tempToken}) async {
    String? token = (await StorageHelper.getLoginData())?.accessToken;

    // Fallback to tempToken if stored token is empty
    if (token == null || token.isEmpty) {
      token = tempToken;
    }

    Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    // print('TOKEN INTERCEPTOR: $token');

    // Only add Authorization if token is non-null and non-empty
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
