import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/feature/attendance/data_source/remote/attendance_service.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_state.dart';

class AttendanceSessionsCubit extends Cubit<AttendanceSessionsState> {
  final AttendanceService attendanceService;

  AttendanceSessionsCubit({required this.attendanceService})
    : super(AttendanceSessionsInitialState());

  final List<AttendanceSessionModel> _sessions = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  int? _circleId;

  // ── Load first page ───────────────────────────────────────
  Future<void> loadSessions({required int circleId}) async {
    _circleId = circleId;
    _sessions.clear();
    _currentPage = 1;
    _hasNextPage = true;

    emit(AttendanceSessionsLoadingState());
    final result = await attendanceService.getCircleSessions(
      circleId: circleId,
      page: _currentPage,
    );
    result.fold(
      (err) => emit(AttendanceSessionsFailureState(errMessage: err)),
      (data) {
        _sessions.addAll(data.items);
        _hasNextPage = data.meta.hasNextPage;
        emit(
          AttendanceSessionsSuccessState(
            sessions: List.from(_sessions),
            meta: data.meta,
          ),
        );
      },
    );
  }

  // ── Load next page ────────────────────────────────────────
  Future<void> loadMore() async {
    if (!_hasNextPage || _circleId == null) return;

    emit(
      AttendanceSessionsLoadMoreState(currentSessions: List.from(_sessions)),
    );

    _currentPage++;
    final result = await attendanceService.getCircleSessions(
      circleId: _circleId!,
      page: _currentPage,
    );
    result.fold(
      (err) {
        _currentPage--; // rollback
        emit(AttendanceSessionsFailureState(errMessage: err));
      },
      (data) {
        _sessions.addAll(data.items);
        _hasNextPage = data.meta.hasNextPage;
        emit(
          AttendanceSessionsSuccessState(
            sessions: List.from(_sessions),
            meta: data.meta,
          ),
        );
      },
    );
  }

  // ── Open (create) a new session ───────────────────────────
  Future<void> openSession({
    required int circleId,
    required String date,
    String? notes,
    int? scheduleId,
  }) async {
    emit(OpenSessionLoadingState());
    final result = await attendanceService.openSession(
      circleId: circleId,
      date: date,
      notes: notes,
      scheduleId: scheduleId,
    );
    result.fold((err) => emit(OpenSessionFailureState(errMessage: err)), (
      session,
    ) {
      // Prepend new session to local list
      _sessions.insert(0, session);
      emit(OpenSessionSuccessState(session: session));
    });
  }
}
