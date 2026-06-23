// student_recitations_state.dart

import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_recitation_detail_model.dart';

abstract class StudentRecitationsState {}

class StudentRecitationsInitialState extends StudentRecitationsState {}

class StudentRecitationsLoadingState extends StudentRecitationsState {}

class StudentRecitationsLoadMoreState extends StudentRecitationsState {
  final List<StudentRecitationDetailModel> currentItems;
  StudentRecitationsLoadMoreState({required this.currentItems});
}

class StudentRecitationsSuccessState extends StudentRecitationsState {
  final List<StudentRecitationDetailModel> items;
  final StudentPaginationModel pagination;
  StudentRecitationsSuccessState({
    required this.items,
    required this.pagination,
  });
}

class StudentRecitationsFailureState extends StudentRecitationsState {
  final String errMessage;
  StudentRecitationsFailureState({required this.errMessage});
}
