// recitation_model.dart

class RecitationStudentRef {
  final int id;
  final String fullName;

  const RecitationStudentRef({required this.id, required this.fullName});

  factory RecitationStudentRef.fromJson(Map<String, dynamic> json) {
    return RecitationStudentRef(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
    );
  }
}

class RecitationTeacherRef {
  final int id;
  final String name;

  const RecitationTeacherRef({required this.id, required this.name});

  factory RecitationTeacherRef.fromJson(Map<String, dynamic> json) {
    return RecitationTeacherRef(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class RecitationModel {
  final int id;
  final int cycleId;
  final int circleId;
  final int studentId;
  final int teacherId;
  final RecitationStudentRef student;
  final RecitationTeacherRef teacher;
  final String recitationType;
  final int? fromPage;
  final int? toPage;
  final int? surahId;
  final int? fromAyah;
  final int? toAyah;
  // final int? pagesCount;
  final String rating;
  final int pointsAwarded;
  final String recitedAt;
  final String createdAt;

  const RecitationModel({
    required this.id,
    required this.cycleId,
    required this.circleId,
    required this.studentId,
    required this.teacherId,
    required this.student,
    required this.teacher,
    required this.recitationType,
    this.fromPage,
    this.toPage,
    this.surahId,
    this.fromAyah,
    this.toAyah,
    // this.pagesCount,
    required this.rating,
    required this.pointsAwarded,
    required this.recitedAt,
    required this.createdAt,
  });

  factory RecitationModel.fromJson(Map<String, dynamic> json) {
    return RecitationModel(
      id: json['id'] as int,
      cycleId: json['cycle_id'] as int,
      circleId: json['circle_id'] as int,
      studentId: json['student_id'] as int,
      teacherId: json['teacher_id'] as int,
      student: RecitationStudentRef.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      teacher: RecitationTeacherRef.fromJson(
        json['teacher'] as Map<String, dynamic>,
      ),
      recitationType: json['recitation_type'] as String,
      fromPage: json['from_page'] as int?,
      toPage: json['to_page'] as int?,
      surahId: json['surah_id'] as int?,
      fromAyah: json['from_ayah'] as int?,
      toAyah: json['to_ayah'] as int?,
      // pagesCount: json['pages_count'] as int?,
      rating: json['rating'] as String,
      pointsAwarded: json['points_awarded'] as int,
      recitedAt: json['recited_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
