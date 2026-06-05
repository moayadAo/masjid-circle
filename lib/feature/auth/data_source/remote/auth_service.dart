import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/end_point.dart';
import 'package:masjid/feature/auth/data_source/model/auth_response_model.dart';

abstract class AuthService {
  Future<Either<String, AuthResponseModel>> login({
    required String username,
    required String password,
    String? deviceName,
  });

  Future<Either<String, MeResponseModel>> getMe();

  Future<Either<String, String>> logout();
}

class AuthServiceImpl implements AuthService {
  final ApiConsumer apiConsumer;

  AuthServiceImpl({required this.apiConsumer});

  @override
  Future<Either<String, AuthResponseModel>> login({
    required String username,
    required String password,
    String? deviceName,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.login,
        data: {
          'username': username,
          'password': password,
          'device_name': deviceName ?? 'mobile_device',
        },
      );
      return Right(AuthResponseModel.fromJson(response));
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (customException) {
        return Left(ErrorParser.parseError(customException));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, MeResponseModel>> getMe() async {
    try {
      final response = await apiConsumer.get(EndPoint.me);
      return Right(MeResponseModel.fromJson(response));
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (customException) {
        return Left(ErrorParser.parseError(customException));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      final response = await apiConsumer.post(EndPoint.logout);
      final message =
          response['data']?['message'] as String? ?? 'تم تسجيل الخروج';
      return Right(message);
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (customException) {
        return Left(ErrorParser.parseError(customException));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }
}
