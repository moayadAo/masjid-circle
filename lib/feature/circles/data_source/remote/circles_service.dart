import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/end_point.dart';
import 'package:masjid/feature/circles/data_source/model/circle_model.dart';
import 'package:masjid/feature/circles/data_source/model/circle_student_model.dart';

abstract class CirclesService {
  Future<Either<String, List<CircleModel>>> getMyCircles();
  Future<Either<String, List<CircleStudentModel>>> getCircleStudents({
    required int circleId,
  });
}

class CirclesServiceImpl implements CirclesService {
  final ApiConsumer apiConsumer;

  CirclesServiceImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<CircleModel>>> getMyCircles() async {
    try {
      final response = await apiConsumer.get(EndPoint.myCircles);
      final list = (response['data'] as List)
          .map((e) => CircleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (custom) {
        return Left(ErrorParser.parseError(custom));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, List<CircleStudentModel>>> getCircleStudents({
    required int circleId,
  }) async {
    try {
      final response = await apiConsumer.get(EndPoint.circleStudents(circleId));
      final list = (response['data'] as List)
          .map((e) => CircleStudentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (custom) {
        return Left(ErrorParser.parseError(custom));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }
}
