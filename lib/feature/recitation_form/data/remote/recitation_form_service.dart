// recitation_service.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/end_point.dart';

import '../models/recitation_model.dart';

abstract class RecitationFormService {
  /// Submits a new recitation record for a student.
  ///
  /// Only the fields relevant to [recitationType] need to be provided
  /// (the rest can stay null), matching the API contract:
  /// - `pages`: [fromPage], [toPage]
  /// - `surah`: [surahId]
  /// - `ayah_range`: [surahId], [fromAyah], [toAyah]
  Future<Either<String, RecitationModel>> createRecitation({
    required int cycleId,
    required int circleId,
    required int studentId,
    required String recitationType,
    required String rating,
    required String recitedAt,
    int? fromPage,
    int? toPage,
    int? surahId,
    int? fromAyah,
    int? toAyah,
    int? pagesCount,
    String? notes,
  });
}

class RecitationFormServiceImpl implements RecitationFormService {
  final ApiConsumer apiConsumer;

  RecitationFormServiceImpl({required this.apiConsumer});

  @override
  Future<Either<String, RecitationModel>> createRecitation({
    required int cycleId,
    required int circleId,
    required int studentId,
    required String recitationType,
    required String rating,
    required String recitedAt,
    int? fromPage,
    int? toPage,
    int? surahId,
    int? fromAyah,
    int? toAyah,
    int? pagesCount,
    String? notes,
  }) async {
    try {
      final body = {
        'cycle_id': cycleId,
        'circle_id': circleId,
        'student_id': studentId,
        'recitation_type': recitationType,
        'from_page': fromPage,
        'to_page': toPage,
        'surah_id': surahId,
        'from_ayah': fromAyah,
        'to_ayah': toAyah,
        'pages_count': pagesCount,
        'rating': rating,
        'recited_at': recitedAt,
        'notes': notes,
      };

      final response = await apiConsumer.post(
        EndPoint.recitations,
        data: body,
      );

      return Right(
        RecitationModel.fromJson(response['data'] as Map<String, dynamic>),
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
