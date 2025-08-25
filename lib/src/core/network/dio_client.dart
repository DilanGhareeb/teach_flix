import 'package:dio/dio.dart';

import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  DioClient({required String baseUrl, Map<String, dynamic>? headers})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      )..interceptors.addAll([LoggerInterceptor()]);

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<ResponseBody>> getStream(
    String url, {
    required String accessToken,
    required String acceptLanguage,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post<ResponseBody>(
        url,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'key':
                "8271f49c5b21252a6095b901beec288328f5aa15de59542ee4ca923f1ff3406a",
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
            'Accept-Language': acceptLanguage,
          },
        ),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}
