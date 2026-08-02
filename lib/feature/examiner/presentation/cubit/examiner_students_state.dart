import 'package:masjid/shared/models/pagination_model.dart';

import '../../data/models/examiner_student_model.dart';

abstract class ExaminerStudentsState {}

class ExaminerStudentsInitialState extends ExaminerStudentsState {}

class ExaminerStudentsLoadingState extends ExaminerStudentsState {}

class ExaminerStudentsLoadingMoreState extends ExaminerStudentsState {
  final List<ExaminerStudentModel> students;
  ExaminerStudentsLoadingMoreState({required this.students});
}

class ExaminerStudentsSuccessState extends ExaminerStudentsState {
  final List<ExaminerStudentModel> students;
  final bool hasMore;
  final PaginationMeta? meta;

  ExaminerStudentsSuccessState({
    required this.students,
    required this.hasMore,
    this.meta,
  });
}

class ExaminerStudentsFailureState extends ExaminerStudentsState {
  final String errMessage;
  ExaminerStudentsFailureState({required this.errMessage});
}

// ── Barcode lookup (QR scan / manual code entry) ───────────
class ExaminerBarcodeLoadingState extends ExaminerStudentsState {}

class ExaminerBarcodeSuccessState extends ExaminerStudentsState {
  final ExaminerStudentModel student;
  ExaminerBarcodeSuccessState({required this.student});
}

class ExaminerBarcodeFailureState extends ExaminerStudentsState {
  final String errMessage;
  ExaminerBarcodeFailureState({required this.errMessage});
}
