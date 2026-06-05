import 'package:dio/dio.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/api_interceptor.dart';
import 'package:masjid/core/network/api/end_point.dart';

class DioConsumer extends ApiConsumer {
  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.BASEURL;
    dio.options.connectTimeout = Duration(seconds: 10);
    // dio.options.receiveTimeout = Duration(seconds: 10);
    // dio.options.sendTimeout = Duration(seconds: 10);

    dio.interceptors.add(ApiInterceptors());

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        logPrint: (object) => print(object),
        // requestUrl: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    );
  }
  final Dio dio;
  @override
  Future delete(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future get(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameter,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future patch(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future put(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future post(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
    final ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await dio.post(
        path,
        // إذا كان data بالفعل FormData لا نحوله مرة ثانية
        data: (isFormData && data is! FormData) ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
        onSendProgress: onSendProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
