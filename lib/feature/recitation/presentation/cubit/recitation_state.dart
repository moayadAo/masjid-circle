// general_recitation_state.dart

import '../../data/models/student_lookup_model.dart';

abstract class RecitationState {}

class RecitationInitial extends RecitationState {}

class RecitationLoading extends RecitationState {}

class RecitationSuccess extends RecitationState {
  final StudentLookupModel data;
  RecitationSuccess({required this.data});
}

class RecitationFailure extends RecitationState {
  final String errMessage;
  RecitationFailure({required this.errMessage});
}
