// daily_report_service.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

abstract class DailyReportService {
  /// GET /api/mobile/v1/recitations/daily-report
  /// [date] format: YYYY-MM-DD, defaults to today on the server if omitted.
  Future<Either<String, List<DailyReportStudentModel>>> getDailyReport({
    required int circleId,
    String? date,
  });
}

class DailyReportServiceImpl implements DailyReportService {
  final ApiConsumer apiConsumer;

  DailyReportServiceImpl({required this.apiConsumer});

  static const String _endpoint = 'api/mobile/v1/recitations/daily-report';

  @override
  Future<Either<String, List<DailyReportStudentModel>>> getDailyReport({
    required int circleId,
    String? date,
  }) async {
    try {
      final response = await apiConsumer.get(
        _endpoint,
        queryParameter: {
          'circle_id': circleId,
          if (date != null && date.isNotEmpty) 'date': date,
        },
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final students = data
          .map(
            (e) => DailyReportStudentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      // Sort alphabetically by student name (Arabic-aware)
      students.sort((a, b) => a.studentName.compareTo(b.studentName));

      return Right(students);
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
