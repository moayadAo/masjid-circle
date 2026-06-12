// student_lookup_model.dart
// Models matching: GET /api/mobile/v1/students/lookup

class StudentInfoModel {
  final int id;
  final String fullName;
  final String publicCode;
  final String nickname;
  final String birthDate;
  final String schoolGrade;
  final String status;

  const StudentInfoModel({
    required this.id,
    required this.fullName,
    required this.publicCode,
    required this.nickname,
    required this.birthDate,
    required this.schoolGrade,
    required this.status,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) {
    return StudentInfoModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      publicCode: json['public_code'] as String,
      nickname: json['nickname'] as String,
      birthDate: json['birth_date'] as String,
      schoolGrade: json['school_grade'] as String,
      status: json['status'] as String,
    );
  }
}

class CircleInfoModel {
  final int id;
  final String name;
  final String status;

  const CircleInfoModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CircleInfoModel.fromJson(Map<String, dynamic> json) {
    return CircleInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
    );
  }
}

class CycleInfoModel {
  final int id;
  final String name;
  final String status;

  const CycleInfoModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CycleInfoModel.fromJson(Map<String, dynamic> json) {
    return CycleInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
    );
  }
}

class StudentLookupModel {
  final StudentInfoModel student;
  final CircleInfoModel circle;
  final CycleInfoModel cycle;
  final int totalPoints;

  const StudentLookupModel({
    required this.student,
    required this.circle,
    required this.cycle,
    required this.totalPoints,
  });

  factory StudentLookupModel.fromJson(Map<String, dynamic> json) {
    return StudentLookupModel(
      student: StudentInfoModel.fromJson(json['student'] as Map<String, dynamic>),
      circle: CircleInfoModel.fromJson(json['circle'] as Map<String, dynamic>),
      cycle: CycleInfoModel.fromJson(json['cycle'] as Map<String, dynamic>),
      totalPoints: json['total_points'] as int,
    );
  }
}
