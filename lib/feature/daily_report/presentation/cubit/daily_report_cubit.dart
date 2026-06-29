// daily_report_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/daily_report/data/remote/daily_report_service.dart';

import 'daily_report_state.dart';

class DailyReportCubit extends Cubit<DailyReportState> {
  final DailyReportService service;

  DailyReportCubit({required this.service}) : super(DailyReportInitialState());

  /// Returns today as YYYY-MM-DD string.
  static String get todayFormatted {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}'
        '-${now.month.toString().padLeft(2, '0')}'
        '-${now.day.toString().padLeft(2, '0')}';
  }

  /// Fetches the daily report. Pass [date] as YYYY-MM-DD or null for today.
  Future<void> fetchReport({required int circleId, String? date}) async {
    final reportDate = date ?? todayFormatted;
    emit(DailyReportLoadingState());

    final result = await service.getDailyReport(
      circleId: circleId,
      date: reportDate,
    );

    result.fold(
      (err) => emit(DailyReportFailureState(errMessage: err)),
      (students) => emit(
        DailyReportSuccessState(students: students, reportDate: reportDate),
      ),
    );
  }

  /// Called right before share begins to show the sharing indicator.
  void startSharing() {
    final current = state;
    if (current is DailyReportSuccessState) {
      emit(DailyReportSharingState(
        students: current.students,
        reportDate: current.reportDate,
      ));
    }
  }

  /// Called when sharing is done (success or failure) to go back to success.
  void doneSharing() {
    final current = state;
    if (current is DailyReportSharingState) {
      emit(DailyReportSuccessState(
        students: current.students,
        reportDate: current.reportDate,
      ));
    }
  }
}
