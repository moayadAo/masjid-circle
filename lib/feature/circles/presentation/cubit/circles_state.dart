import 'package:masjid/feature/circles/data_source/model/circle_model.dart';
import 'package:masjid/feature/circles/data_source/model/circle_student_model.dart';

abstract class CirclesState {}

class CirclesInitialState extends CirclesState {}

// ── My Circles ────────────────────────────────────────────
class GetCirclesLoadingState extends CirclesState {}

class GetCirclesSuccessState extends CirclesState {
  final List<CircleModel> circles;
  GetCirclesSuccessState({required this.circles});
}

class GetCirclesFailureState extends CirclesState {
  final String errMessage;
  GetCirclesFailureState({required this.errMessage});
}

// ── Circle Students ───────────────────────────────────────
class GetStudentsLoadingState extends CirclesState {}

class GetStudentsSuccessState extends CirclesState {
  final List<CircleStudentModel> students;
  GetStudentsSuccessState({required this.students});
}

class GetStudentsFailureState extends CirclesState {
  final String errMessage;
  GetStudentsFailureState({required this.errMessage});
}
