// export_report_button.dart
//
// A self-contained button that orchestrates the full export flow:
//   1. Opens ExportReportDialog for date selection.
//   2. Fetches the report via DailyReportCubit.
//   3. Captures report pages as images and shares them.
//
// Place this widget anywhere you have access to a DailyReportCubit
// (via BlocProvider in the parent) and a circleName string.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/feature/daily_report/controller/report_share_controller.dart';
import 'package:masjid/feature/daily_report/presentation/cubit/daily_report_cubit.dart';
import 'package:masjid/feature/daily_report/presentation/cubit/daily_report_state.dart';
import 'package:masjid/feature/daily_report/widgets/export_report_dialog.dart';

class ExportReportButton extends StatelessWidget {
  final int circleId;
  final String circleName;

  const ExportReportButton({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DailyReportCubit(service: getIt()),
      child: _ExportReportButtonBody(
        circleId: circleId,
        circleName: circleName,
      ),
    );
  }
}

class _ExportReportButtonBody extends StatelessWidget {
  final int circleId;
  final String circleName;

  const _ExportReportButtonBody({
    required this.circleId,
    required this.circleName,
  });

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ExportReportDialog(
        onExport: (date, showStudentsWithoutRecitation) =>
            _onExport(context, date, showStudentsWithoutRecitation),
      ),
    );
  }

  Future<void> _onExport(
    BuildContext context,
    String date,
    bool showStudentsWithoutRecitation,
  ) async {
    final cubit = context.read<DailyReportCubit>();

    // 1. Fetch report data
    await cubit.fetchReport(circleId: circleId, date: date);

    if (!context.mounted) return;

    final state = cubit.state;
    if (state is DailyReportFailureState) {
      AppToast.error(context, state.errMessage);
      return;
    }

    if (state is! DailyReportSuccessState) return;

    // 2. Start sharing state (shows spinner on button)
    cubit.startSharing();

    // 3. Capture pages as images and share
    final success = await ReportShareController.captureAndShare(
      context: context,
      students: state.students,
      reportDate: state.reportDate,
      circleName: circleName,
      showStudentsWithoutRecitation: showStudentsWithoutRecitation,
    );

    if (!context.mounted) return;
    cubit.doneSharing();

    if (!success) {
      AppToast.error(context, 'تعذرت مشاركة التقرير، حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyReportCubit, DailyReportState>(
      builder: (context, state) {
        final isLoading =
            state is DailyReportLoadingState ||
            state is DailyReportSharingState;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : () => _openDialog(context),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColor.primaryFixed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColor.primaryContainer.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryContainer,
                      ),
                    )
                  else
                    const Icon(
                      Icons.ios_share_rounded,
                      size: AppIconSize.sm,
                      color: AppColor.primaryContainer,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    isLoading ? 'جارٍ التصدير...' : 'تصدير تقرير',
                    style: AppTextStyle.labelLg(
                      context,
                      AppColor.primaryContainer,
                      12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
