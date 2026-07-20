// attendance_full_table_capture.dart
//
// Off-screen, non-scrollable version of the attendance table.
// Used exclusively for image capture so the exported image contains
// every student row, not just the ones currently visible on screen.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/feature/attendance/widgets/attendance_header_widget.dart';
import 'package:masjid/feature/attendance/widgets/attendance_record_row_widget.dart';

class AttendanceFullTableCapture extends StatelessWidget {
  final AttendanceSessionModel session;
  final List<AttendanceRecordModel>? records;

  const AttendanceFullTableCapture({
    super.key,
    required this.session,
    this.records,
  });

  @override
  Widget build(BuildContext context) {
    final displayRecords = records ?? session.sortedRecords;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: AppColor.background,
        child: Container(
          width: 480, // Fixed width for consistent capture results
          color: AppColor.background,
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AttendanceHeaderWidget(session: session),
              const _CaptureColumnLabelsRow(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    for (final record in displayRecords) ...[
                      AttendanceRecordRowWidget(
                        record: record,
                        onStatusChanged: (_) {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaptureColumnLabelsRow extends StatelessWidget {
  const _CaptureColumnLabelsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColor.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'الطالب',
              style: AppTextStyle.labelLg(context, AppColor.onPrimary, null),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _CaptureColLabel(
                  icon: Icons.check_circle_outline,
                  label: 'حاضر',
                ),
                _CaptureColLabel(icon: Icons.schedule_outlined, label: 'متأخر'),
                _CaptureColLabel(icon: Icons.cancel_outlined, label: 'غائب'),
                _CaptureColLabel(icon: Icons.history_outlined, label: 'بعذر'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureColLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CaptureColLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColor.onPrimary, size: AppIconSize.sm),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyle.labelLg(context, AppColor.onPrimary, 10),
        ),
      ],
    );
  }
}
