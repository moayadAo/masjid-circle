import '../../data/models/juz_exam_model.dart';

abstract class AllJuzExamsState {}

class AllJuzExamsInitialState extends AllJuzExamsState {}

class AllJuzExamsLoadingState extends AllJuzExamsState {}

class AllJuzExamsSuccessState extends AllJuzExamsState {
  final List<JuzExamModel> exams;
  final bool hasMore;
  AllJuzExamsSuccessState({required this.exams, required this.hasMore});
}

class AllJuzExamsLoadingMoreState extends AllJuzExamsState {
  final List<JuzExamModel> exams;
  AllJuzExamsLoadingMoreState({required this.exams});
}

class AllJuzExamsFailureState extends AllJuzExamsState {
  final String errMessage;
  AllJuzExamsFailureState({required this.errMessage});
}
