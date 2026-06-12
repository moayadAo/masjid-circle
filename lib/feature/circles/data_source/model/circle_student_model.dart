class CircleStudentModel {
  final int id;
  final int mosqueId;
  final String publicCode;
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
  final String guardianStatus;
  final String? notes;
  final String status;
  final String createdAt;

  const CircleStudentModel({
    required this.id,
    required this.mosqueId,
    required this.publicCode,
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
    required this.guardianStatus,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  /// First letter of full name for avatar
  String get avatarLetter =>
      fullName.isNotEmpty ? fullName[0] : '؟';

  factory CircleStudentModel.fromJson(Map<String, dynamic> json) {
    return CircleStudentModel(
      id: json['id'] as int,
      mosqueId: json['mosque_id'] as int,
      publicCode: json['public_code'] as String,
      fullName: json['full_name'] as String,
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
      guardianStatus: json['guardian_status'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
