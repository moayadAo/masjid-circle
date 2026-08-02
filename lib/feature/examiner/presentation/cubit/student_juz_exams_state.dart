import 'package:masjid/shared/models/pagination_model.dart';

import '../../data/models/juz_exam_model.dart';

abstract class StudentJuzExamsState {}

class StudentJuzExamsInitialState extends StudentJuzExamsState {}

class StudentJuzExamsLoadingState extends StudentJuzExamsState {}

class StudentJuzExamsLoadingMoreState extends StudentJuzExamsState {
  final List<JuzExamModel> exams;
  StudentJuzExamsLoadingMoreState({required this.exams});
}

class StudentJuzExamsSuccessState extends StudentJuzExamsState {
  final List<JuzExamModel> exams;
  final bool hasMore;
  final PaginationMeta? meta;

  StudentJuzExamsSuccessState({
    required this.exams,
    required this.hasMore,
    this.meta,
  });
}

class StudentJuzExamsFailureState extends StudentJuzExamsState {
  final String errMessage;
  StudentJuzExamsFailureState({required this.errMessage});
}
