import 'package:masjid/feature/attendance/helper/attendance_sort_helper.dart';

// ── Attendance Record ─────────────────────────────────────
class AttendanceRecordModel {
  final int id;
  final int attendanceSessionId;
  final int studentId;
  final AttendanceStudentModel student;
  String status; // mutable for local UI updates
  final String? checkInTime;
  final String? checkOutTime;
  String? note; // mutable for local UI updates
  final int? pointsAwarded;

  AttendanceRecordModel({
    required this.id,
    required this.attendanceSessionId,
    required this.studentId,
    required this.student,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.note,
    this.pointsAwarded,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as int,
      attendanceSessionId: json['attendance_session_id'] as int,
      studentId: json['student_id'] as int,
      student: AttendanceStudentModel.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      note: json['note'] as String?,
      pointsAwarded: json['points_awarded'] as int?,
    );
  }

  /// For submitting bulk records
  Map<String, dynamic> toRequestJson() => {
    'student_id': studentId,
    'status': status,
    'note': note,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
  };
}

class AttendanceStudentModel {
  final int id;
  final String fullName;
  final String publicCode;

  const AttendanceStudentModel({
    required this.id,
    required this.fullName,
    required this.publicCode,
  });

  String get avatarLetter => fullName.isNotEmpty ? fullName[0] : '؟';

  factory AttendanceStudentModel.fromJson(Map<String, dynamic> json) =>
      AttendanceStudentModel(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        publicCode: json['public_code'] as String,
      );
}

// ── Opened-by user inside session ────────────────────────
class SessionOpenerModel {
  final int id;
  final String name;

  const SessionOpenerModel({required this.id, required this.name});

  factory SessionOpenerModel.fromJson(Map<String, dynamic> json) =>
      SessionOpenerModel(id: json['id'] as int, name: json['name'] as String);
}

// ── Attendance Session ────────────────────────────────────
class AttendanceSessionModel {
  final int id;
  final int circleId;
  final int? scheduleId;
  final String date;
  final SessionOpenerModel openedBy;
  final String status;
  final String? notes;
  final String createdAt;
  final List<AttendanceRecordModel> records;
  final int? recordsCount;

  const AttendanceSessionModel({
    required this.id,
    required this.circleId,
    this.scheduleId,
    required this.date,
    required this.openedBy,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.records,
    this.recordsCount,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] as int,
      circleId: json['circle_id'] as int,
      scheduleId: json['schedule_id'] as int?,
      date: json['date'] as String,
      openedBy: SessionOpenerModel.fromJson(
        json['opened_by'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      records: json['records'] != null
          ? (json['records'] as List)
                .map(
                  (e) =>
                      AttendanceRecordModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      recordsCount: json['records_count'] as int?,
    );
  }

  /// Arabic label for status badge
  String get statusLabel {
    switch (status) {
      case 'submitted':
        return 'تم التسليم';
      case 'draft':
        return 'مسودة';
      case 'locked':
        return 'مقفلة';
      default:
        return status;
    }
  }

  List<AttendanceRecordModel> get sortedRecords =>
      AttendanceSortHelper.sortByArabicName(
        records,
        (record) => record.student.fullName,
      );
}
