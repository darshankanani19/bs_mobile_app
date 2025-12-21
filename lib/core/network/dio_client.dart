// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:beauty_salon/core/network/api_interceptor.dart';
// import 'package:beauty_salon/core/utils/api_end_points.dart';
//
//
// class DioClient {
//   late Dio _dio;
//   late String baseUrl;
//
//   static final DioClient _dioClient = DioClient._internal();
//
//   factory DioClient() {
//     return _dioClient;
//   }
//
//   DioClient._internal() {
//     try {
//       baseUrl = ApiEndPoints.baseUrl;
//     } catch (e) {
//       throw Exception(
//         'DIO is not initialized. Call Init.initialize() before using DioClient.',
//       );
//     }
//     _dio = Dio();
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         validateStatus: (status) {
//           // This allows you to receive 400 status codes as a response
//           return status! <= 500;
//         },
//       ),
//     );
//     _dio
//       ..options.baseUrl = baseUrl
//       ..httpClientAdapter
//       ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
//
//     _dio.interceptors.add(ApiInterceptors().getInterceptor());
//   }
//
//   Future<dynamic> get(
//       String uri, {
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//         ProgressCallback? onReceiveProgress,
//       }) async {
//     try {
//       var response = await _dio.get(
//         uri,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response.data;
//     } on SocketException catch (e) {
//       throw SocketException(e.toString());
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> post(
//       String uri, {
//         data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//       }) async {
//     try {
//       var response = await _dio.post(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//       return response.data;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<bool> download(
//       String url,
//       String saveFilePath, {
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//         ProgressCallback? onSendProgress,
//         ProgressCallback? onReceiveProgress,
//       }) async {
//     _dio.interceptors.clear();
//     try {
//       await _dio.download(url, saveFilePath);
//       return true;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> postMultipartFile(
//       String uri, {
//         data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//         ProgressCallback? onSendProgress,
//         ProgressCallback? onReceiveProgress,
//       }) async {
//     try {
//       var response = await _dio.post(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response.data;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> patch(
//       String uri, {
//         data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//         ProgressCallback? onSendProgress,
//         ProgressCallback? onReceiveProgress,
//       }) async {
//     try {
//       var response = await _dio.patch(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response.data;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> put(
//       String uri, {
//         data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//         ProgressCallback? onSendProgress,
//         ProgressCallback? onReceiveProgress,
//       }) async {
//     try {
//       var response = await _dio.put(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response.data;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> delete(
//       String uri, {
//         data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//         CancelToken? cancelToken,
//       }) async {
//     try {
//       var response = await _dio.delete(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return response.data;
//     } on FormatException catch (_) {
//       throw const FormatException('Something went wrong');
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:beauty_salon/core/network/api_interceptor.dart';
import 'package:beauty_salon/core/utils/api_end_points.dart';

class DioClient {
  late Dio _dio;
  late String baseUrl;

  static final DioClient _dioClient = DioClient._internal();

  factory DioClient() {
    return _dioClient;
  }

  DioClient._internal() {
    baseUrl = ApiEndPoints.baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! <= 500,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );

    _dio.interceptors.add(ApiInterceptors(dio: _dio).getInterceptor());
  }

  Dio get client => _dio;

  // ---- HTTP METHODS ---- //

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> download(String url, String saveFilePath) async {
    _dio.interceptors.clear(); // Optional: disable interceptor for downloads
    try {
      await _dio.download(url, saveFilePath);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postMultipartFile(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
