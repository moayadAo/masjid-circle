import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/juz_exam_model.dart';
import '../../data_source/remote/examiner_service.dart';
import 'juz_exam_form_state.dart';

class JuzExamFormCubit extends Cubit<JuzExamFormState> {
  final ExaminerService examinerService;

  JuzExamFormCubit({required this.examinerService})
    : super(JuzExamFormInitialState());

  int? juzNumber;
  DateTime passedAt = DateTime.now();
  JuzExamRating? rating;
  String notes = '';

  DateTime _todayOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void resetForm() {
    juzNumber = null;
    passedAt = _todayOnly();
    rating = null;
    notes = '';
    emit(JuzExamFormInitialState());
  }

  void selectJuz(int juz) {
    juzNumber = juz;
    emit(JuzExamFormInitialState());
  }

  void selectDate(DateTime date) {
    passedAt = date;
    emit(JuzExamFormInitialState());
  }

  void selectRating(JuzExamRating value) {
    rating = value;
    emit(JuzExamFormInitialState());
  }

  void updateNotes(String value) {
    notes = value;
  }

  bool get isNotesRequired => rating == JuzExamRating.failed;

  Future<void> submit({
    required int studentId,
    required int circleId,
    required int cycleId,
  }) async {
    if (juzNumber == null) {
      emit(JuzExamFormValidationState(errMessage: 'يرجى اختيار الجزء المختبر'));
      return;
    }
    if (rating == null) {
      emit(JuzExamFormValidationState(errMessage: 'يرجى اختيار التقييم'));
      return;
    }
    if (isNotesRequired && notes.trim().isEmpty) {
      emit(
        JuzExamFormValidationState(errMessage: 'يرجى كتابة ملاحظات التقييم'),
      );
      return;
    }

    final today = _todayOnly();
    if (passedAt.isAfter(today)) {
      emit(JuzExamFormValidationState(errMessage: 'لا يمكن اختيار تاريخ لاحق ليومنا'));
      return;
    }

    emit(JuzExamFormSubmittingState());
    final passedAtStr =
        '${passedAt.year.toString().padLeft(4, '0')}-'
        '${passedAt.month.toString().padLeft(2, '0')}-'
        '${passedAt.day.toString().padLeft(2, '0')}';

    final result = await examinerService.createJuzExam(
      circleId: circleId,
      studentId: studentId,
      juzNumber: juzNumber!,
      rating: rating!.value,
      passedAt: passedAtStr,
      notes: notes.trim().isEmpty ? null : notes.trim(),
    );

    result.fold(
      (err) => emit(JuzExamFormFailureState(errMessage: err)),
      (exam) => emit(JuzExamFormSuccessState(exam: exam)),
    );
  }
}
