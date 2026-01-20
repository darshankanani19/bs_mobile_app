import 'package:bs/Core/helper/storage_helper.dart';

class ApiHeaders {
  static Future<Map<String, dynamic>> getHeaders({String? tempToken}) async {
    String? token = await StorageHelper.getAccessToken();

    if (token == null || token.isEmpty) {
      token = tempToken;
    }

    Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
