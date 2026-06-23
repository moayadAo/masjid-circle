// student_info_state.dart

import 'package:masjid/feature/student_profile/data_source/model/student_detail_model.dart';

abstract class StudentInfoState {}

class StudentInfoInitialState extends StudentInfoState {}

class StudentInfoLoadingState extends StudentInfoState {}

class StudentInfoSuccessState extends StudentInfoState {
  final StudentDetailModel student;
  StudentInfoSuccessState({required this.student});
}

class StudentInfoFailureState extends StudentInfoState {
  final String errMessage;
  StudentInfoFailureState({required this.errMessage});
}
