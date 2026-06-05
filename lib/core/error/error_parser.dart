import 'package:masjid/core/error/exception/exception.dart';

class ErrorParser {
  static String parseError(dynamic error) {
    // ✅ التعامل مع الاستثناءات المحددة أولاً
    if (error is GuestException) return error.message;
    if (error is NetworkException) return error.message;
    if (error is ServerException) return error.errorModel.message;

    // Fallback للأخطاء القديمة
    final errorString = error.toString();
    if (errorString.contains('SocketException'))
      return 'لا يوجد اتصال بالإنترنت';
    if (errorString.contains('TimeoutException')) return 'انتهت مهلة الاتصال';

    return 'حدث خطأ غير معروف، يرجى المحاولة لاحقاً';
  }

  // ✅ مساعدة الـ Bloc على معرفة نوع الخطأ
  static bool isGuestError(dynamic error) => error is GuestException;
  static bool isNetworkError(dynamic error) => error is NetworkException;
}
