// recitation_service.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/end_point.dart';

import '../models/student_lookup_model.dart';

/// NOTE: add the following constant inside core/network/api/end_point.dart
/// static String studentLookup = "${api}mobile/v1/students/lookup";

abstract class RecitationService {
  /// Lookup a student by his QR / public code (used for both
  /// QR scan and manual student-id entry).
  Future<Either<String, StudentLookupModel>> lookupStudentByCode({
    required String publicCode,
  });
}

class RecitationServiceImpl implements RecitationService {
  final ApiConsumer apiConsumer;

  RecitationServiceImpl({required this.apiConsumer});

  @override
  Future<Either<String, StudentLookupModel>> lookupStudentByCode({
    required String publicCode,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.studentLookup,
        queryParameter: {'public_code': publicCode},
      );

      return Right(
        StudentLookupModel.fromJson(response['data'] as Map<String, dynamic>),
      );
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
