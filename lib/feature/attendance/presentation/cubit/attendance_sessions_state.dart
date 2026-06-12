import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/shared/models/pagination_model.dart';

abstract class AttendanceSessionsState {}

class AttendanceSessionsInitialState extends AttendanceSessionsState {}

class AttendanceSessionsLoadingState extends AttendanceSessionsState {}

class AttendanceSessionsLoadMoreState extends AttendanceSessionsState {
  final List<AttendanceSessionModel> currentSessions;
  AttendanceSessionsLoadMoreState({required this.currentSessions});
}

class AttendanceSessionsSuccessState extends AttendanceSessionsState {
  final List<AttendanceSessionModel> sessions;
  final PaginationMeta meta;
  AttendanceSessionsSuccessState({required this.sessions, required this.meta});
}

class AttendanceSessionsFailureState extends AttendanceSessionsState {
  final String errMessage;
  AttendanceSessionsFailureState({required this.errMessage});
}

// ── Open (create) session ─────────────────────────────────
class OpenSessionLoadingState extends AttendanceSessionsState {}

class OpenSessionSuccessState extends AttendanceSessionsState {
  final AttendanceSessionModel session;
  OpenSessionSuccessState({required this.session});
}

class OpenSessionFailureState extends AttendanceSessionsState {
  final String errMessage;
  OpenSessionFailureState({required this.errMessage});
}
