// report_page_widget.dart
//
// One "page" of the daily report. Rendered off-screen via RepaintBoundary
// for image capture. Fixed width 800px to produce a clean high-res image.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

import '../../widgets/report_student_row.dart';
import '../../widgets/report_table_header_row.dart';

/// Width used for all off-screen report renders.
const double kReportWidth = 800.0;

class ReportPageWidget extends StatelessWidget {
  final List<DailyReportStudentModel> students;
  final String reportDate;
  final String circleName;
  final int pageNumber;
  final int totalPages;
  final int totalStudents;

  const ReportPageWidget({
    super.key,
    required this.students,
    required this.reportDate,
    required this.circleName,
    required this.pageNumber,
    required this.totalPages,
    required this.totalStudents,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: kReportWidth,
        color: AppColor.surfaceContainerLowest,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Report header ─────────────────────────────
            _ReportHeader(reportDate: reportDate),
            const SizedBox(height: 16),

            // ── Info summary bar ──────────────────────────
            _InfoSummaryBar(circleName: circleName, reportDate: reportDate),
            const SizedBox(height: 16),

            // ── Table ─────────────────────────────────────
            _ReportTable(students: students),
            const SizedBox(height: 12),

            // ── Footer ────────────────────────────────────
            _ReportFooter(
              totalStudents: totalStudents,
              pageNumber: pageNumber,
              totalPages: totalPages,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ReportHeader extends StatelessWidget {
  final String reportDate;

  const _ReportHeader({required this.reportDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تقرير التسميع اليومي',
                style: AppTextStyle.headlineMd(context).copyWith(
                  color: AppColor.primaryContainer,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'إلهي أنت مقصودي ورضاك مطلوبي',
                style: AppTextStyle.bodyMd(context).copyWith(
                  color: AppColor.onSurfaceVariant,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        // Date box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColor.outlineVariant.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [_MetaRow(label: 'تاريخ الإصدار', value: reportDate)],
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: AppTextStyle.labelLg(context, AppColor.onSurfaceVariant, 11),
        ),
        Text(
          value,
          style: AppTextStyle.labelLg(
            context,
            AppColor.onSurface,
            11,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ── Info summary bar ──────────────────────────────────────────────────────────

class _InfoSummaryBar extends StatelessWidget {
  final String circleName;
  final String reportDate;

  const _InfoSummaryBar({required this.circleName, required this.reportDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColor.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          _SummaryItem(label: 'الحلقة', value: circleName),
          _SummaryDivider(),
          _SummaryItem(label: 'تقرير التسميع في تاريخ', value: reportDate),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.labelLg(context, AppColor.onSurfaceVariant, 11),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primaryContainer, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColor.outlineVariant.withOpacity(0.4),
    );
  }
}

// ── Table ─────────────────────────────────────────────────────────────────────

class _ReportTable extends StatelessWidget {
  final List<DailyReportStudentModel> students;
  const _ReportTable({required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColor.outlineVariant.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const ReportTableHeaderRow(),
          ...students.asMap().entries.map(
            (entry) => ReportStudentRow(
              student: entry.value,
              isEvenRow: entry.key.isEven,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _ReportFooter extends StatelessWidget {
  final int totalStudents;
  final int pageNumber;
  final int totalPages;

  const _ReportFooter({
    required this.totalStudents,
    required this.pageNumber,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'إجمالي الطلاب: $totalStudents',
          style: AppTextStyle.labelLg(context, AppColor.onSurfaceVariant, 11),
        ),
        Text(
          'الصفحة $pageNumber من $totalPages',
          style: AppTextStyle.labelLg(context, AppColor.onSurfaceVariant, 11),
        ),
      ],
    );
  }
}
