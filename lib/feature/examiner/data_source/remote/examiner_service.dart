import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/error/error_parser.dart';
import 'package:masjid/core/error/exception/exception.dart';
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/shared/models/pagination_model.dart';

import '../../data/models/examiner_student_model.dart';
import '../../data/models/juz_exam_model.dart';

abstract class ExaminerService {
  /// GET /teacher/students
  Future<Either<String, PaginatedResult<ExaminerStudentModel>>> getStudents({
    String? search,
    String? status,
    String? schoolGrade,
    int? circleId,
    bool? studentWithoutCircle,
    int page = 1,
    int perPage = 10,
    String? orderBy,
    String? orderDirection,
    bool unlimited = false,
  });

  /// GET /teacher/students/by-barcode
  Future<Either<String, ExaminerStudentModel>> getStudentByBarcode({
    required String publicCode,
  });

  /// GET /teacher/students/{student}/juz-exams
  Future<Either<String, PaginatedResult<JuzExamModel>>> getStudentJuzExams({
    required int studentId,
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int perPage = 15,
    String? orderBy,
    String? orderDirection,
  });

  /// GET /teacher/juz-exams (mosque-wide)
  Future<Either<String, PaginatedResult<JuzExamModel>>> getAllJuzExams({
    int? studentId,
    int? circleId,
    int? teacherId,
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int perPage = 15,
    String? orderBy,
    String? orderDirection,
  });

  /// POST /teacher/juz-exams
  Future<Either<String, JuzExamModel>> createJuzExam({
    required int circleId,
    required int studentId,
    required int juzNumber,
    required String rating,
    required String passedAt,
    String? notes,
  });

  /// GET /teacher/juz-exams/{id}
  Future<Either<String, JuzExamModel>> getJuzExam({required int examId});

  /// PATCH /teacher/juz-exams/{id}
  Future<Either<String, JuzExamModel>> updateJuzExam({
    required int examId,
    int? juzNumber,
    String? rating,
    String? passedAt,
    String? notes,
  });

  /// DELETE /teacher/juz-exams/{id}
  Future<Either<String, bool>> deleteJuzExam({required int examId});
}

class ExaminerServiceImpl implements ExaminerService {
  final ApiConsumer apiConsumer;

  ExaminerServiceImpl({required this.apiConsumer});

  static const String _base = 'api/mobile/v1/teacher';
  static const String _students = '$_base/students';
  static const String _studentByBarcode = '$_base/students/by-barcode';
  static String _studentJuzExams(int studentId) =>
      '$_base/students/$studentId/juz-exams';
  static const String _juzExams = '$_base/juz-exams';
  static String _juzExam(int id) => '$_base/juz-exams/$id';

  @override
  Future<Either<String, PaginatedResult<ExaminerStudentModel>>> getStudents({
    String? search,
    String? status,
    String? schoolGrade,
    int? circleId,
    bool? studentWithoutCircle,
    int page = 1,
    int perPage = 10,
    String? orderBy,
    String? orderDirection,
    bool unlimited = false,
  }) async {
    try {
      int cycleId = await getIt<AuthCubit>().cycleId;
      final response = await apiConsumer.get(
        _students,
        queryParameter: {
          if (search != null && search.isNotEmpty) 'search': search,
          // if (status != null) 'status': status,
          // if (schoolGrade != null) 'school_grade': schoolGrade,
          // if (circleId != null) 'circle_id': circleId,
          'cycle_id': cycleId,

          // if (studentWithoutCircle != null)
          //   'student_without_circle': studentWithoutCircle,
          'page': page,
          'per_page': perPage,
          // if (orderBy != null) 'order_by': orderBy,
          // if (orderDirection != null) 'order_direction': orderDirection,
          // if (unlimited) 'unlimited': true,
        },
      );
      final items = (response['data'] as List)
          .map((e) => ExaminerStudentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final meta = PaginationMeta.fromJson(
        response['meta']['pagination'] as Map<String, dynamic>,
      );
      return Right(PaginatedResult(items: items, meta: meta));
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, ExaminerStudentModel>> getStudentByBarcode({
    required String publicCode,
  }) async {
    try {
      final response = await apiConsumer.get(
        _studentByBarcode,
        queryParameter: {'public_code': publicCode},
      );
      return Right(
        ExaminerStudentModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, PaginatedResult<JuzExamModel>>> getStudentJuzExams({
    required int studentId,
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int perPage = 15,
    String? orderBy,
    String? orderDirection,
  }) async {
    try {
      final response = await apiConsumer.get(
        _studentJuzExams(studentId),
        queryParameter: {
          if (juzNumber != null) 'juz_number': juzNumber,
          if (rating != null) 'rating': rating,
          if (date != null) 'date': date,
          if (dateFrom != null) 'date_from': dateFrom,
          if (dateTo != null) 'date_to': dateTo,
          'page': page,
          'per_page': perPage,
          if (orderBy != null) 'order_by': orderBy,
          if (orderDirection != null) 'order_direction': orderDirection,
        },
      );
      final items = (response['data'] as List)
          .map((e) => JuzExamModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final meta = PaginationMeta.fromJson(
        response['meta'] as Map<String, dynamic>,
      );
      return Right(PaginatedResult(items: items, meta: meta));
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, PaginatedResult<JuzExamModel>>> getAllJuzExams({
    int? studentId,
    int? circleId,
    int? teacherId,
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int perPage = 15,
    String? orderBy,
    String? orderDirection,
  }) async {
    try {
      int cycleId = await getIt<AuthCubit>().cycleId;
      final response = await apiConsumer.get(
        _juzExams,
        queryParameter: {
          // if (studentId != null) 'student_id': studentId,
          // if (circleId != null) 'circle_id': circleId,
          'cycle_id': cycleId,
          // if (teacherId != null) 'teacher_id': teacherId,
          if (juzNumber != null) 'juz_number': juzNumber,
          if (rating != null) 'rating': rating,
          if (date != null) 'date': date,
          if (dateFrom != null) 'date_from': dateFrom,
          if (dateTo != null) 'date_to': dateTo,
          'page': page,
          'per_page': perPage,
          if (orderBy != null) 'order_by': orderBy,
          if (orderDirection != null) 'order_direction': orderDirection,
        },
      );
      final items = (response['data'] as List)
          .map((e) => JuzExamModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final meta = PaginationMeta.fromJson(
        response['meta']['pagination'] as Map<String, dynamic>,
      );
      return Right(PaginatedResult(items: items, meta: meta));
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, JuzExamModel>> createJuzExam({
    required int circleId,
    required int studentId,
    required int juzNumber,
    required String rating,
    required String passedAt,
    String? notes,
  }) async {
    try {
      int cycleId = await getIt<AuthCubit>().cycleId;
      final response = await apiConsumer.post(
        _juzExams,
        data: {
          'cycle_id': cycleId,
          'circle_id': circleId,
          'student_id': studentId,
          'juz_number': juzNumber,
          'rating': rating,
          'passed_at': passedAt,
          if (notes != null) 'notes': notes,
        },
      );
      return Right(
        JuzExamModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, JuzExamModel>> getJuzExam({required int examId}) async {
    try {
      final response = await apiConsumer.get(_juzExam(examId));
      return Right(
        JuzExamModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, JuzExamModel>> updateJuzExam({
    required int examId,
    int? juzNumber,
    String? rating,
    String? passedAt,
    String? notes,
  }) async {
    try {
      final response = await apiConsumer.patch(
        _juzExam(examId),
        data: {
          if (juzNumber != null) 'juz_number': juzNumber,
          if (rating != null) 'rating': rating,
          if (passedAt != null) 'passed_at': passedAt,
          if (notes != null) 'notes': notes,
        },
      );
      return Right(
        JuzExamModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  @override
  Future<Either<String, bool>> deleteJuzExam({required int examId}) async {
    try {
      await apiConsumer.delete(_juzExam(examId));
      return const Right(true);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Left(ErrorParser.parseError(e));
    }
  }

  /// Shared Dio error -> Either<String,...> mapping, matching the pattern
  /// already used across AttendanceService / AuthService.
  Either<String, T> _handleDioError<T>(DioException e) {
    try {
      handleDioException(e);
      return const Left('حدث خطأ غير متوقع');
    } catch (c) {
      return Left(ErrorParser.parseError(c));
    }
  }
}
