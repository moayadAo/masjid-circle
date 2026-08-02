import '../../data/models/juz_exam_model.dart';

abstract class JuzExamFormState {}

class JuzExamFormInitialState extends JuzExamFormState {}

class JuzExamFormSubmittingState extends JuzExamFormState {}

class JuzExamFormSuccessState extends JuzExamFormState {
  final JuzExamModel exam;
  JuzExamFormSuccessState({required this.exam});
}

class JuzExamFormFailureState extends JuzExamFormState {
  final String errMessage;
  JuzExamFormFailureState({required this.errMessage});
}

class JuzExamFormValidationState extends JuzExamFormState {
  final String errMessage;
  JuzExamFormValidationState({required this.errMessage});
}
