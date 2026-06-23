// student_recitations_cubit.dart

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_recitation_detail_model.dart';
import 'package:masjid/feature/student_profile/data_source/remote/student_profile_service.dart';

import 'student_recitations_state.dart';

class StudentRecitationsCubit extends Cubit<StudentRecitationsState> {
  final StudentProfileService service;

  StudentRecitationsCubit({required this.service})
    : super(StudentRecitationsInitialState());

  final List<StudentRecitationDetailModel> _items = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  int? _studentId;

  String? _fromDate;
  String? _toDate;

  String? get fromDate => _fromDate;
  String? get toDate => _toDate;
  bool get hasActiveFilter => _fromDate != null || _toDate != null;

  // ── Load first page ───────────────────────────────────────

  Future<void> loadRecitations({required int studentId}) async {
    _studentId = studentId;
    _items.clear();
    _currentPage = 1;
    _hasNextPage = true;

    emit(StudentRecitationsLoadingState());

    final result = await service.getStudentRecitations(
      studentId: studentId,
      page: _currentPage,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    result.fold(
      (err) => emit(StudentRecitationsFailureState(errMessage: err)),
      (data) {
        _items.addAll(data.items);
        _hasNextPage = data.pagination.hasNextPage;
        emit(
          StudentRecitationsSuccessState(
            items: List.from(_items),
            pagination: data.pagination,
          ),
        );
      },
    );
  }

  // ── Load next page ───────────────────────────────────────

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasNextPage || _studentId == null) return;

    _isLoadingMore = true;
    emit(StudentRecitationsLoadMoreState(currentItems: List.from(_items)));

    _currentPage++;
    final result = await service.getStudentRecitations(
      studentId: _studentId!,
      page: _currentPage,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    result.fold(
      (err) {
        log('StudentRecitationsCubit: loadMore failure, err: $err');
        _currentPage--;
        emit(StudentRecitationsFailureState(errMessage: err));
      },
      (data) {
        log(
          'StudentRecitationsCubit: loadMore success, items: ${data.items.length}, hasNextPage: ${data.pagination.hasNextPage}',
        );
        _items.addAll(data.items);
        _hasNextPage = data.pagination.hasNextPage;
        emit(
          StudentRecitationsSuccessState(
            items: List.from(_items),
            pagination: data.pagination,
          ),
        );
      },
    );
    _isLoadingMore = false;
  }

  // ── Filters ──────────────────────────────────────────────

  Future<void> applyFilter({String? fromDate, String? toDate}) async {
    _fromDate = fromDate;
    _toDate = toDate;
    if (_studentId != null) {
      await loadRecitations(studentId: _studentId!);
    }
  }

  Future<void> clearFilter() async {
    _fromDate = null;
    _toDate = null;
    if (_studentId != null) {
      await loadRecitations(studentId: _studentId!);
    }
  }
}
