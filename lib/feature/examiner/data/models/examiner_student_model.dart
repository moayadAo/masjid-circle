// ── Mini circle reference embedded in Student ─────────────
class MiniCircleModel {
  final int id;
  final String name;

  const MiniCircleModel({required this.id, required this.name});

  factory MiniCircleModel.fromJson(Map<String, dynamic> json) =>
      MiniCircleModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );
}

// ── Student (as returned by /teacher/students & by-barcode) ─
class ExaminerStudentModel {
  final int id;
  final int mosqueId;
  final String publicCode;
  final String firstName;
  final String fullName;
  final String? fatherName;
  final String? motherName;
  final String? nickname;
  final String? birthDate;
  final String? schoolGrade;
  final String? fatherPhone;
  final String? motherPhone;
  final String? studentPhone;
  final String? address;
  final String? fatherJob;
  final String? guardianStatus;
  final String? notes;
  final String status; // active | inactive | archived
  final MiniCircleModel? circle;
  final String? createdAt;

  const ExaminerStudentModel({
    required this.id,
    required this.mosqueId,
    required this.publicCode,
    required this.firstName,
    required this.fullName,
    this.fatherName,
    this.motherName,
    this.nickname,
    this.birthDate,
    this.schoolGrade,
    this.fatherPhone,
    this.motherPhone,
    this.studentPhone,
    this.address,
    this.fatherJob,
    this.guardianStatus,
    this.notes,
    required this.status,
    this.circle,
    this.createdAt,
  });

  bool get isActive => status == 'active';

  /// Two-letter Arabic initials fallback avatar (e.g. "ع م")
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '؟';
    if (parts.length == 1) return parts.first.characters.first;
    return '${parts[0].characters.first} ${parts[1].characters.first}';
  }

  factory ExaminerStudentModel.fromJson(Map<String, dynamic> json) {
    return ExaminerStudentModel(
      id: json['id'] as int,
      mosqueId: json['mosque_id'] as int? ?? 0,
      publicCode: json['public_code'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      nickname: json['nickname'] as String?,
      birthDate: json['birth_date'] as String?,
      schoolGrade: json['school_grade'] as String?,
      fatherPhone: json['father_phone'] as String?,
      motherPhone: json['mother_phone'] as String?,
      studentPhone: json['student_phone'] as String?,
      address: json['address'] as String?,
      fatherJob: json['father_job'] as String?,
      guardianStatus: json['guardian_status'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'active',
      circle: json['circle'] != null
          ? MiniCircleModel.fromJson(json['circle'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
    );
  }
}

// Needed for `.characters` on String (Arabic-safe first-letter extraction).
extension _StringCharacters on String {
  Characters get characters => Characters(this);
}

class Characters {
  final String _s;
  const Characters(this._s);
  String get first => _s.isEmpty ? '؟' : _s.substring(0, 1);
}
