// student_profile_service.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_detail_model.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_recitation_detail_model.dart';

abstract class StudentProfileService {
  Future<Either<String, StudentDetailModel>> getStudentDetail({
    required int studentId,
  });

  Future<Either<String, StudentRecitationsPageModel>> getStudentRecitations({
    required int studentId,
    int page = 1,
    int perPage = 15,
    String? fromDate,
    String? toDate,
  });
}

class StudentProfileServiceImpl implements StudentProfileService {
  final ApiConsumer apiConsumer;

  StudentProfileServiceImpl({required this.apiConsumer});

  static String _studentDetail(int id) => 'api/mobile/v1/students/$id';
  static String _studentRecitations(int id) =>
      'api/mobile/v1/students/$id/recitations';

  @override
  Future<Either<String, StudentDetailModel>> getStudentDetail({
    required int studentId,
  }) async {
    try {
      final response = await apiConsumer.get(_studentDetail(studentId));
      return Right(
        StudentDetailModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (c) {
        return Left(ErrorParser.parseError(c));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, StudentRecitationsPageModel>> getStudentRecitations({
    required int studentId,
    int page = 1,
    int perPage = 15,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final response = await apiConsumer.get(
        _studentRecitations(studentId),
        queryParameter: {
          'page': page,
          'per_page': perPage,
          if (fromDate != null && fromDate.isNotEmpty) 'from_date': fromDate,
          if (toDate != null && toDate.isNotEmpty) 'to_date': toDate,
        },
      );
      log(
        'StudentProfileServiceImpl.getStudentRecitations response: $response',
        name: 'StudentProfileServiceImpl',
      );
      return Right(
        StudentRecitationsPageModel.fromJson(response as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      try {
        handleDioException(e);
        return const Left('حدث خطأ غير متوقع');
      } catch (c) {
        return Left(ErrorParser.parseError(c));
      }
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }
}
