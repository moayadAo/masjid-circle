import 'examiner_student_model.dart' show MiniCircleModel;

// ── Rating enum (exact API string values) ─────────────────
enum JuzExamRating { good, veryGood, excellent, failed }

extension JuzExamRatingX on JuzExamRating {
  String get value {
    switch (this) {
      case JuzExamRating.good:
        return 'good';
      case JuzExamRating.veryGood:
        return 'very_good';
      case JuzExamRating.excellent:
        return 'excellent';
      case JuzExamRating.failed:
        return 'failed';
    }
  }

  String get arabicLabel {
    switch (this) {
      case JuzExamRating.good:
        return 'جيد';
      case JuzExamRating.veryGood:
        return 'جيد جداً';
      case JuzExamRating.excellent:
        return 'ممتاز';
      case JuzExamRating.failed:
        return 'لم ينجح';
    }
  }

  static JuzExamRating fromValue(String? value) {
    switch (value) {
      case 'good':
        return JuzExamRating.good;
      case 'very_good':
        return JuzExamRating.veryGood;
      case 'excellent':
        return JuzExamRating.excellent;
      case 'failed':
        return JuzExamRating.failed;
      default:
        return JuzExamRating.good;
    }
  }
}

// ── Mini refs embedded in JuzExam ──────────────────────────
class MiniStudentModel {
  final int id;
  final String fullName;

  const MiniStudentModel({required this.id, required this.fullName});

  factory MiniStudentModel.fromJson(Map<String, dynamic> json) =>
      MiniStudentModel(
        id: json['id'] as int,
        fullName: json['full_name'] as String? ?? '',
      );
}

class MiniTeacherModel {
  final int id;
  final String name;

  const MiniTeacherModel({required this.id, required this.name});

  factory MiniTeacherModel.fromJson(Map<String, dynamic> json) =>
      MiniTeacherModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );
}

// MiniCircleModel is imported from examiner_student_model.dart (shared).

class MiniCycleModel {
  final int id;
  final String name;

  const MiniCycleModel({required this.id, required this.name});

  factory MiniCycleModel.fromJson(Map<String, dynamic> json) => MiniCycleModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
  );
}

// ── Juz Exam ────────────────────────────────────────────────
class JuzExamModel {
  final int id;
  final int juzNumber;
  final String rating; // raw string, use JuzExamRatingX.fromValue to convert
  final int? pointsAwarded;
  final String passedAt; // date, e.g. 2026-07-20
  final String? notes;
  final MiniStudentModel? student;
  final MiniTeacherModel? teacher;
  final MiniCircleModel? circle;
  final MiniCycleModel? cycle;

  const JuzExamModel({
    required this.id,
    required this.juzNumber,
    required this.rating,
    this.pointsAwarded,
    required this.passedAt,
    this.notes,
    this.student,
    this.teacher,
    this.circle,
    this.cycle,
  });

  JuzExamRating get ratingEnum => JuzExamRatingX.fromValue(rating);

  factory JuzExamModel.fromJson(Map<String, dynamic> json) {
    return JuzExamModel(
      id: json['id'] as int,
      juzNumber: json['juz_number'] as int,
      rating: json['rating'] as String? ?? 'good',
      pointsAwarded: json['points_awarded'] as int?,
      passedAt: json['passed_at'] as String? ?? '',
      notes: json['notes'] as String?,
      student: json['student'] != null
          ? MiniStudentModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] != null
          ? MiniTeacherModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      circle: json['circle'] != null
          ? MiniCircleModel.fromJson(json['circle'] as Map<String, dynamic>)
          : null,
      cycle: json['cycle'] != null
          ? MiniCycleModel.fromJson(json['cycle'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Reused from examiner_student_model.dart's MiniCircleModel definition would
// collide, so this file defines its own copy above intentionally
// (kept independent per-file to respect single-responsibility of models).
