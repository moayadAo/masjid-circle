// daily_report_state.dart

import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

abstract class DailyReportState {}

class DailyReportInitialState extends DailyReportState {}

class DailyReportLoadingState extends DailyReportState {}

class DailyReportSuccessState extends DailyReportState {
  final List<DailyReportStudentModel> students;
  final String reportDate;
  DailyReportSuccessState({required this.students, required this.reportDate});
}

class DailyReportFailureState extends DailyReportState {
  final String errMessage;
  DailyReportFailureState({required this.errMessage});
}

/// Fired while capturing & sharing images — shows progress to user.
class DailyReportSharingState extends DailyReportState {
  final List<DailyReportStudentModel> students;
  final String reportDate;
  DailyReportSharingState({required this.students, required this.reportDate});
}
