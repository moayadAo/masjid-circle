import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/feature/attendance/data_source/remote/attendance_service.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_detail_state.dart';

class AttendanceDetailCubit extends Cubit<AttendanceDetailState> {
  final AttendanceService attendanceService;

  AttendanceDetailCubit({required this.attendanceService})
    : super(AttendanceDetailInitialState());

  AttendanceSessionModel? _session;
  AttendanceSessionModel? get session => _session;

  // ── Load session (from API or prefilled after creation) ──
  Future<void> loadSession({required int sessionId}) async {
    emit(LoadSessionLoadingState());
    final result = await attendanceService.getSession(sessionId: sessionId);
    result.fold((err) => emit(LoadSessionFailureState(errMessage: err)), (
      session,
    ) {
      _session = session;
      emit(LoadSessionSuccessState(session: session));
    });
  }

  /// Called when session just got created — no need to fetch again
  void loadFromSession(AttendanceSessionModel session) {
    _session = session;
    emit(LoadSessionSuccessState(session: session));
  }

  // ── Optimistic local status change ───────────────────────
  void changeRecordStatus({required int studentId, required String newStatus}) {
    if (_session == null) return;
    for (final record in _session!.records) {
      if (record.studentId == studentId) {
        record.status = newStatus;
        break;
      }
    }
    emit(RecordStatusChangedState(session: _session!));
  }

  // ── Bulk submit all records ───────────────────────────────
  Future<void> submitAllRecords() async {
    if (_session == null) return;
    emit(SubmitRecordsLoadingState());
    final result = await attendanceService.submitRecords(
      sessionId: _session!.id,
      records: _session!.records,
    );
    result.fold((err) => emit(SubmitRecordsFailureState(errMessage: err)), (
      updatedSession,
    ) {
      _session = updatedSession;
      emit(SubmitRecordsSuccessState(session: updatedSession));
    });
  }

  // ── Update single record (PATCH) — used for quick tap ────
  Future<void> updateSingleRecord({
    required int recordId,
    required String status,
    String? note,
  }) async {
    emit(UpdateRecordLoadingState(recordId: recordId));
    final result = await attendanceService.updateSingleRecord(
      recordId: recordId,
      status: status,
      note: note,
    );
    result.fold((err) => emit(UpdateRecordFailureState(errMessage: err)), (
      updatedRecord,
    ) {
      // Patch locally
      if (_session != null) {
        for (var i = 0; i < _session!.records.length; i++) {
          if (_session!.records[i].id == recordId) {
            _session!.records[i].status = updatedRecord.status;
            _session!.records[i].note = updatedRecord.note;
            break;
          }
        }
      }
      emit(UpdateRecordSuccessState(record: updatedRecord));
    });
  }

  // ── Bulk update session + records (PATCH session) ────────
  Future<void> updateSessionBulk({String? date, String? notes}) async {
    if (_session == null) return;
    emit(SubmitRecordsLoadingState());
    final result = await attendanceService.updateSession(
      sessionId: _session!.id,
      date: date,
      notes: notes,
      records: _session!.records,
    );
    result.fold((err) => emit(SubmitRecordsFailureState(errMessage: err)), (
      updatedSession,
    ) {
      _session = updatedSession;
      emit(SubmitRecordsSuccessState(session: updatedSession));
    });
  }
}
