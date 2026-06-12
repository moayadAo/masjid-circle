import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/shared/models/pagination_model.dart';

abstract class AttendanceService {
  /// GET /circles/{circleId}/attendance-sessions (paginated)
  Future<Either<String, PaginatedResult<AttendanceSessionModel>>>
  getCircleSessions({required int circleId, int page = 1, int perPage = 15});

  /// POST /attendance-sessions — create + get pre-filled records
  Future<Either<String, AttendanceSessionModel>> openSession({
    required int circleId,
    required String date,
    int? scheduleId,
    String? notes,
  });

  /// GET /attendance-sessions/{sessionId}
  Future<Either<String, AttendanceSessionModel>> getSession({
    required int sessionId,
  });

  /// POST /attendance-sessions/{sessionId}/records — bulk submit
  Future<Either<String, AttendanceSessionModel>> submitRecords({
    required int sessionId,
    required List<AttendanceRecordModel> records,
  });

  /// PATCH /attendance-records/{recordId} — update single record
  Future<Either<String, AttendanceRecordModel>> updateSingleRecord({
    required int recordId,
    required String status,
    String? note,
  });

  /// PATCH /attendance-sessions/{sessionId} — bulk update + session info
  Future<Either<String, AttendanceSessionModel>> updateSession({
    required int sessionId,
    String? date,
    String? notes,
    List<AttendanceRecordModel>? records,
  });
}

class AttendanceServiceImpl implements AttendanceService {
  final ApiConsumer apiConsumer;

  AttendanceServiceImpl({required this.apiConsumer});

  static String _sessions(int circleId) =>
      'api/mobile/v1/circles/$circleId/attendance-sessions';
  static const String _openSession = 'api/mobile/v1/attendance-sessions';
  static String _getSession(int id) => 'api/mobile/v1/attendance-sessions/$id';
  static String _submitRecords(int sessionId) =>
      'api/mobile/v1/attendance-sessions/$sessionId/records';
  static String _singleRecord(int recordId) =>
      'api/mobile/v1/attendance-records/$recordId';
  static String _updateSession(int sessionId) =>
      'api/mobile/v1/attendance-sessions/$sessionId';

  @override
  Future<Either<String, PaginatedResult<AttendanceSessionModel>>>
  getCircleSessions({
    required int circleId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await apiConsumer.get(
        _sessions(circleId),
        queryParameter: {'page': page, 'per_page': perPage},
      );
      final items = (response['data'] as List)
          .map(
            (e) => AttendanceSessionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      final meta = PaginationMeta.fromJson(
        response['meta']['pagination'] as Map<String, dynamic>,
      );
      return Right(PaginatedResult(items: items, meta: meta));
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
  Future<Either<String, AttendanceSessionModel>> openSession({
    required int circleId,
    required String date,
    int? scheduleId,
    String? notes,
  }) async {
    try {
      final response = await apiConsumer.post(
        _openSession,
        data: {
          'circle_id': circleId,
          'date': date,
          if (scheduleId != null) 'schedule_id': scheduleId,
          if (notes != null) 'notes': notes,
        },
      );
      return Right(
        AttendanceSessionModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
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
  Future<Either<String, AttendanceSessionModel>> getSession({
    required int sessionId,
  }) async {
    try {
      final response = await apiConsumer.get(_getSession(sessionId));
      return Right(
        AttendanceSessionModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
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
  Future<Either<String, AttendanceSessionModel>> submitRecords({
    required int sessionId,
    required List<AttendanceRecordModel> records,
  }) async {
    try {
      final response = await apiConsumer.post(
        _submitRecords(sessionId),
        data: {'records': records.map((r) => r.toRequestJson()).toList()},
      );
      return Right(
        AttendanceSessionModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
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
  Future<Either<String, AttendanceRecordModel>> updateSingleRecord({
    required int recordId,
    required String status,
    String? note,
  }) async {
    try {
      final response = await apiConsumer.patch(
        _singleRecord(recordId),
        data: {'status': status, if (note != null) 'note': note},
      );
      return Right(
        AttendanceRecordModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
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
  Future<Either<String, AttendanceSessionModel>> updateSession({
    required int sessionId,
    String? date,
    String? notes,
    List<AttendanceRecordModel>? records,
  }) async {
    try {
      final body = <String, dynamic>{
        if (date != null) 'date': date,
        if (notes != null) 'notes': notes,
        if (records != null)
          'records': records.map((r) => r.toRequestJson()).toList(),
      };
      final response = await apiConsumer.patch(
        _updateSession(sessionId),
        data: body,
      );
      return Right(
        AttendanceSessionModel.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
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
