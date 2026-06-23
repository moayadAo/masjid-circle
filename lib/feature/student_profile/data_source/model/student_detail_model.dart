// student_detail_model.dart

class StudentDetailModel {
  final int id;
  final int mosqueId;
  final String publicCode;
  final String fullName;
  final String? firstName;
  final String fatherName;
  final String? motherName;
  final String? nickname;
  final String? birthDate;
  final String? schoolGrade;
  final String? fatherPhone;
  final String? motherPhone;
  final String? studentPhone;
  final String? address;
  final String? fatherJob;
  final String? guardianStatus; // normal | divorced | father_deceased | mother_deceased | other
  final String? notes;
  final String status; // active | inactive | archived
  final String createdAt;

  const StudentDetailModel({
    required this.id,
    required this.mosqueId,
    required this.publicCode,
    required this.fullName,
    this.firstName,
    required this.fatherName,
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
    required this.createdAt,
  });

  // ── Display helpers ───────────────────────────────────────

  String get avatarLetter => fullName.isNotEmpty ? fullName[0] : '؟';

  String get statusLabel {
    return switch (status) {
      'active' => 'نشط',
      'inactive' => 'غير نشط',
      'archived' => 'مؤرشف',
      _ => status,
    };
  }

  String get guardianStatusLabel {
    return switch (guardianStatus) {
      'normal' => 'سليمة',
      'divorced' => 'مطلقان',
      'father_deceased' => 'الأب متوفى',
      'mother_deceased' => 'الأم متوفاة',
      'other' => 'أخرى',
      _ => '—',
    };
  }

  String get schoolGradeLabel {
    // API may return raw string like "grade_8" or a proper Arabic label
    if (schoolGrade == null) return '—';
    if (schoolGrade!.startsWith('grade_')) {
      final num = schoolGrade!.replaceFirst('grade_', '');
      return 'الصف $num';
    }
    return schoolGrade!;
  }

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;
  bool get hasAddress => address != null && address!.trim().isNotEmpty;
  bool get hasFatherJob => fatherJob != null && fatherJob!.trim().isNotEmpty;

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailModel(
      id: json['id'] as int,
      mosqueId: json['mosque_id'] as int? ?? 0,
      publicCode: json['public_code'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      firstName: json['first_name'] as String?,
      fatherName: json['father_name'] as String? ?? '',
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
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
