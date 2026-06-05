import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_model/error_model.dart';

// ✅ استثناء جديد لحالة الزائر (غير مسجل)
class GuestException implements Exception {
  final String message;
  GuestException({this.message = 'يجب تسجيل الدخول للقيام بهذا الإجراء'});

  @override
  String toString() => message;
}

// ✅ استثناء جديد لانقطاع الإنترنت
class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'لا يوجد اتصال بالإنترنت'});

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException({required this.errorModel});

  @override
  String toString() => "error :${errorModel.message}";
}

void handleDioException(DioException e) {
  // ✅ معالجة انقطاع الإنترنت هنا مباشرة
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown) {
    throw NetworkException();
  }

  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    throw NetworkException(message: 'انتهت مهلة الاتصال، تحقق من الإنترنت');
  }

  if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        switch (e.response!.statusCode) {
          case 400:
            throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data),
            );
          case 401:
            // ✅ معالجة الزائر (غير مصرح)
            throw GuestException(message: 'يجب تسجيل الدخول أولاً');
          case 403:
            throw GuestException(message: 'غير مصرح لك بالوصول');
          case 404:
            throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data),
            );
          case 409:
            throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data),
            );
          case 422:
            throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data),
            );
          case 500:
          case 504:
            throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data),
            );
        }
      default:
        throw ServerException(
          errorModel: ErrorModel.fromJson(e.response!.data),
        );
    }
  } else {
    throw ServerException(errorModel: ErrorModel(message: 'حدث خطأ غير متوقع'));
  }
}
