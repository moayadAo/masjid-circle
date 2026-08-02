import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/examiner_student_model.dart';
import '../../data_source/remote/examiner_service.dart';
import 'examiner_students_state.dart';

class ExaminerStudentsCubit extends Cubit<ExaminerStudentsState> {
  final ExaminerService examinerService;

  ExaminerStudentsCubit({required this.examinerService})
    : super(ExaminerStudentsInitialState());

  static const int _perPage = 15;

  String _search = '';
  String get currentSearch => _search;

  final List<ExaminerStudentModel> _lastStudents = [];
  List<ExaminerStudentModel> get lastStudents => _lastStudents;

  int _page = 1;
  bool _hasMore = true;

  Future<void> loadStudents({String? search, bool loadMore = false}) async {
    _search = search ?? _search;

    if (!loadMore) {
      _page = 1;
      _hasMore = true;
      _lastStudents.clear();
      emit(ExaminerStudentsLoadingState());
    } else {
      if (!_hasMore) return;
      emit(ExaminerStudentsLoadingMoreState(students: List.from(_lastStudents)));
      _page += 1;
    }

    final result = await examinerService.getStudents(
      search: _search.isEmpty ? null : _search,
      page: _page,
      perPage: _perPage,
      orderBy: 'full_name',
    );

    result.fold(
      (err) {
        if (loadMore) {
          _page = _page > 1 ? _page - 1 : 1;
        }
        emit(ExaminerStudentsFailureState(errMessage: err));
      },
      (paginated) {
        _lastStudents.addAll(paginated.items);
        _hasMore = paginated.meta.hasNextPage;
        emit(
          ExaminerStudentsSuccessState(
            students: List.from(_lastStudents),
            hasMore: _hasMore,
            meta: paginated.meta,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    await loadStudents(loadMore: true);
  }

  // ── Resolve a student by scanned / typed public_code ─────
  Future<void> lookupByBarcode(String publicCode) async {
    if (publicCode.trim().isEmpty) return;
    emit(ExaminerBarcodeLoadingState());
    final result = await examinerService.getStudentByBarcode(
      publicCode: publicCode.trim(),
    );
    result.fold(
      (err) => emit(ExaminerBarcodeFailureState(errMessage: err)),
      (student) => emit(ExaminerBarcodeSuccessState(student: student)),
    );
  }
}
