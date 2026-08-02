import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_source/remote/examiner_service.dart';
import 'student_juz_exams_state.dart';

class StudentJuzExamsCubit extends Cubit<StudentJuzExamsState> {
  final ExaminerService examinerService;

  StudentJuzExamsCubit({required this.examinerService})
    : super(StudentJuzExamsInitialState());

  final List<dynamic> _exams = [];
  int _page = 1;
  bool _hasMore = true;
  int? _studentId;
  int? _juzNumber;
  String? _rating;
  String? _date;
  String? _dateFrom;
  String? _dateTo;

  Future<void> loadExams({
    required int studentId,
    int? juzNumber,
    String? rating,
    String? date,
    String? dateFrom,
    String? dateTo,
    bool loadMore = false,
  }) async {
    _studentId = studentId;
    _juzNumber = juzNumber ?? _juzNumber;
    _rating = rating ?? _rating;
    _date = date ?? _date;
    _dateFrom = dateFrom ?? _dateFrom;
    _dateTo = dateTo ?? _dateTo;

    if (!loadMore) {
      _page = 1;
      _hasMore = true;
      _exams.clear();
      emit(StudentJuzExamsLoadingState());
    } else {
      if (!_hasMore) return;
      emit(StudentJuzExamsLoadingMoreState(exams: List.from(_exams)));
      _page += 1;
    }

    final result = await examinerService.getStudentJuzExams(
      studentId: _studentId!,
      juzNumber: _juzNumber,
      rating: _rating,
      date: _date,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      page: _page,
      perPage: 15,
    );
    log(
      'loadExams: studentId=$_studentId, juzNumber=$_juzNumber, rating=$_rating, date=$_date, dateFrom=$_dateFrom, dateTo=$_dateTo, page=$_page, perPage=15',
    );
    log('loadExams: result=$result');
    result.fold(
      (err) {
        if (loadMore) {
          _page = _page > 1 ? _page - 1 : 1;
        }
        emit(StudentJuzExamsFailureState(errMessage: err));
      },
      (paginated) {
        _exams.addAll(paginated.items);
        _hasMore = paginated.meta.hasNextPage;
        emit(
          StudentJuzExamsSuccessState(
            exams: List.from(_exams),
            hasMore: _hasMore,
            meta: paginated.meta,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (_studentId == null) return;
    await loadExams(studentId: _studentId!, loadMore: true);
  }

  void clearFilters(int studentId) {
    _juzNumber = null;
    _rating = null;
    _date = null;
    _dateFrom = null;
    _dateTo = null;
    loadExams(studentId: studentId);
  }
}
