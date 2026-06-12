// recitation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/recitation/presentation/cubit/recitation_state.dart';

import '../../data/remote/recitation_service.dart';


class RecitationCubit extends Cubit<RecitationState> {
  final RecitationService service;

  RecitationCubit({required this.service})
      : super(RecitationInitial());

  /// Used by both QR scan result and manual student-id submit.
  Future<void> lookupStudent(String publicCode) async {
    if (publicCode.trim().isEmpty) {
      emit(RecitationFailure(errMessage: 'الرجاء إدخال رقم الطالب'));
      return;
    }

    emit(RecitationLoading());

    final response = await service.lookupStudentByCode(
      publicCode: publicCode.trim(),
    );

    response.fold(
      (errMessage) => emit(RecitationFailure(errMessage: errMessage)),
      (data) => emit(RecitationSuccess(data: data)),
    );
  }

  void resetState() => emit(RecitationInitial());
}
