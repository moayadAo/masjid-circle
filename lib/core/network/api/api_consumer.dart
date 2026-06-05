import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
  });
  Future<dynamic> post(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
    final ProgressCallback? onSendProgress,
  });
  Future<dynamic> delete(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  });
  Future<dynamic> patch(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  });
  Future<dynamic> put(
    final String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameter,
    final bool isFormData = false,
  });
}
