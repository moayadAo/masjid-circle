// circle_recitations_service.dart

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/end_point.dart';
import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';

abstract class CircleRecitationsService {
  /// Fetches a paginated list of recitations for a given circle.
  Future<Either<String, CircleRecitationsPageModel>> getCircleRecitations({
    required int circleId,
    int page = 1,
    int perPage = 15,
    int? cycleId,
    String? fromDate,
    String? toDate,
  });
}

class CircleRecitationsServiceImpl implements CircleRecitationsService {
  final ApiConsumer apiConsumer;

  CircleRecitationsServiceImpl({required this.apiConsumer});

  @override
  Future<Either<String, CircleRecitationsPageModel>> getCircleRecitations({
    required int circleId,
    int page = 1,
    int perPage = 15,
    int? cycleId,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (cycleId != null) 'cycle_id': cycleId,
        if (fromDate != null && fromDate.isNotEmpty) 'from_date': fromDate,
        if (toDate != null && toDate.isNotEmpty) 'to_date': toDate,
      };

      final response = await apiConsumer.get(
        EndPoint.circleRecitations(circleId),
        queryParameter: query,
      );
      log(
        'CircleRecitationsServiceImpl.getCircleRecitations response: $response',
        name: 'CircleRecitationsServiceImpl',
      );
      return Right(
        CircleRecitationsPageModel.fromJson(response as Map<String, dynamic>),
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
