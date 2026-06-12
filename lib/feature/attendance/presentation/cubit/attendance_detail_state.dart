import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';

abstract class AttendanceDetailState {}

class AttendanceDetailInitialState extends AttendanceDetailState {}

// ── Load session ──────────────────────────────────────────
class LoadSessionLoadingState extends AttendanceDetailState {}

class LoadSessionSuccessState extends AttendanceDetailState {
  final AttendanceSessionModel session;
  LoadSessionSuccessState({required this.session});
}

class LoadSessionFailureState extends AttendanceDetailState {
  final String errMessage;
  LoadSessionFailureState({required this.errMessage});
}

// ── Local record status changed (optimistic UI) ───────────
class RecordStatusChangedState extends AttendanceDetailState {
  final AttendanceSessionModel session;
  RecordStatusChangedState({required this.session});
}

// ── Submit bulk records ───────────────────────────────────
class SubmitRecordsLoadingState extends AttendanceDetailState {}

class SubmitRecordsSuccessState extends AttendanceDetailState {
  final AttendanceSessionModel session;
  SubmitRecordsSuccessState({required this.session});
}

class SubmitRecordsFailureState extends AttendanceDetailState {
  final String errMessage;
  SubmitRecordsFailureState({required this.errMessage});
}

// ── Update single record ──────────────────────────────────
class UpdateRecordLoadingState extends AttendanceDetailState {
  final int recordId;
  UpdateRecordLoadingState({required this.recordId});
}

class UpdateRecordSuccessState extends AttendanceDetailState {
  final AttendanceRecordModel record;
  UpdateRecordSuccessState({required this.record});
}

class UpdateRecordFailureState extends AttendanceDetailState {
  final String errMessage;
  UpdateRecordFailureState({required this.errMessage});
}
