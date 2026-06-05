import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/error/exception/error_token.dart';
import 'package:masjid/core/network/api/api_key.dart';
import 'package:masjid/core/storage/hive_boxes.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/core/storage/hive_key.dart';

class ApiInterceptors extends Interceptor {
  final Dio dio = Dio();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final accessToken = await getIt<HiveHelper>().getData(
        HiveBoxes.appBox,
        HiveKey.token,
      );
      if (accessToken != null && accessToken.isNotEmpty) {
        final token = "${ApiValue.authorizationValue}$accessToken";
        options.headers[ApiKey.AUTHORIZATION] = token;
      }

      options.headers[ApiKey.ACCEPT] = ApiValue.acceptValue;

      final isMultipart = options.data is FormData;
      if (!isMultipart) {
        options.headers[ApiKey.CONTENTTYPE] = ApiValue.contentTypeValue;
      }

      super.onRequest(options, handler);
    } catch (e) {
      throw ErrorToken(e.toString());
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // معالجة حالة المستخدم المحظور أو التوكن المنتهي
    if (err.response?.statusCode == 403) {
      //await _handleSessionExpired();

      // إنشاء خطأ مخصص
      final customError = DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: DioExceptionType.badResponse,
        error: 'انتهت صلاحية الجلسة',
      );

      return handler.reject(customError);
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map &&
        response.data['message'] == 'تم حظرك من النظام') {
      //_handleSessionExpired();
    }

    super.onResponse(response, handler);
  }
}
