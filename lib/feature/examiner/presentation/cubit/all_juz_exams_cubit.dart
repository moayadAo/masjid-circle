import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/juz_exam_model.dart';
import '../../data_source/remote/examiner_service.dart';
import 'all_juz_exams_state.dart';

/// Sort options exposed in the filter sheet.
enum ExamsOrderBy { passedAt, createdAt, juzNumber }

class AllJuzExamsCubit extends Cubit<AllJuzExamsState> {
  final ExaminerService examinerService;

  AllJuzExamsCubit({required this.examinerService})
    : super(AllJuzExamsInitialState());

  static const int _perPage = 20;

  int _page = 1;
  bool _hasMore = true;
  final List<JuzExamModel> _accumulated = [];

  int? juzNumber;
  String? rating;
  String? date;
  String? dateFrom;
  String? dateTo;
  ExamsOrderBy orderBy = ExamsOrderBy.passedAt;
  String orderDirection = 'desc';

  String get _orderByParam {
    switch (orderBy) {
      case ExamsOrderBy.passedAt:
        return 'passed_at';
      case ExamsOrderBy.createdAt:
        return 'created_at';
      case ExamsOrderBy.juzNumber:
        return 'juz_number';
    }
  }

  // ── Apply filters / initial load ─────────────────────────
  Future<void> applyFilters({
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    ExamsOrderBy? orderBy,
    String? orderDirection,
  }) async {
    this.juzNumber = juzNumber;
    this.rating = rating;
    this.date = date;
    this.dateFrom = dateFrom;
    this.dateTo = dateTo;
    if (orderBy != null) this.orderBy = orderBy;
    if (orderDirection != null) this.orderDirection = orderDirection;

    _page = 1;
    _hasMore = true;
    _accumulated.clear();
    await _fetch(isLoadMore: false);
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is AllJuzExamsLoadingMoreState) return;
    _page += 1;
    await _fetch(isLoadMore: true);
  }

  void clearFilters() {
    applyFilters();
  }

  Future<void> _fetch({required bool isLoadMore}) async {
    if (isLoadMore) {
      emit(AllJuzExamsLoadingMoreState(exams: List.of(_accumulated)));
    } else {
      emit(AllJuzExamsLoadingState());
    }

    final result = await examinerService.getAllJuzExams(
      juzNumber: juzNumber,
      rating: rating,
      date: date,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: _page,
      perPage: _perPage,
      orderBy: _orderByParam,
      orderDirection: orderDirection,
    );

    result.fold((err) {
      if (isLoadMore) {
        _page = _page > 1 ? _page - 1 : 1;
      }
      emit(AllJuzExamsFailureState(errMessage: err));
    }, (paginated) {
      _accumulated.addAll(paginated.items);
      _hasMore = paginated.meta.hasNextPage;
      emit(
        AllJuzExamsSuccessState(
          exams: List.of(_accumulated),
          hasMore: _hasMore,
        ),
      );
    });
  }
}
