// student_info_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/student_profile/data_source/remote/student_profile_service.dart';

import 'student_info_state.dart';

class StudentInfoCubit extends Cubit<StudentInfoState> {
  final StudentProfileService service;

  StudentInfoCubit({required this.service}) : super(StudentInfoInitialState());

  Future<void> loadStudent({required int studentId}) async {
    emit(StudentInfoLoadingState());
    final result = await service.getStudentDetail(studentId: studentId);
    result.fold(
      (err) => emit(StudentInfoFailureState(errMessage: err)),
      (student) => emit(StudentInfoSuccessState(student: student)),
    );
  }
}
