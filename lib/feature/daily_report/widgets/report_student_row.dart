// report_student_row.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

import 'report_rating_chip.dart';

class ReportStudentRow extends StatelessWidget {
  final DailyReportStudentModel student;
  final bool isEvenRow;

  const ReportStudentRow({
    super.key,
    required this.student,
    required this.isEvenRow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: student.didNotReciteToday
            ? AppColor.errorContainer.withOpacity(0.25)
            : isEvenRow
            ? AppColor.surfaceContainerLowest
            : AppColor.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: AppColor.outlineVariant.withOpacity(0.4)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Student name ──────────────────────────────
            _Cell(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: AppTextStyle.bodyMd(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: student.didNotReciteToday
                          ? AppColor.error
                          : AppColor.onSurface,
                    ),
                  ),
                  if (student.didNotReciteToday) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 12,
                          color: AppColor.error,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'لم يُسمِّع اليوم',
                          style: AppTextStyle.labelLg(
                            context,
                            AppColor.error,
                            10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            _VerticalDivider(),

            // ── Excellent ─────────────────────────────────
            _RatingCell(
              entries: student.recitationsByRating.excellent,
              rating: ReportRating.excellent,
            ),

            _VerticalDivider(),

            // ── Very Good ─────────────────────────────────
            _RatingCell(
              entries: student.recitationsByRating.veryGood,
              rating: ReportRating.veryGood,
            ),

            _VerticalDivider(),

            // ── Good ──────────────────────────────────────
            _RatingCell(
              entries: student.recitationsByRating.good,
              rating: ReportRating.good,
            ),

            _VerticalDivider(),

            // ── Failed ──────────────────────────────────────
            _RatingCell(
              entries: student.recitationsByRating.failed,
              rating: ReportRating.failed,
            ),

            _VerticalDivider(),

            // ── Last recitation ───────────────────────────
            _Cell(
              flex: 2,
              child: student.lastRecitationDate != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.lastRecitationDate!,
                          style: AppTextStyle.bodyMd(
                            context,
                          ).copyWith(fontSize: 11, color: AppColor.onSurface),
                        ),
                      ],
                    )
                  : Text(
                      '—',
                      style: AppTextStyle.bodyMd(context).copyWith(
                        color: AppColor.outlineVariant,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingCell extends StatelessWidget {
  final List<DailyReportRecitationEntry> entries;
  final ReportRating rating;

  const _RatingCell({required this.entries, required this.rating});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _Cell(
        flex: 3,
        child: Text(
          '—',
          style: AppTextStyle.bodyMd(context).copyWith(
            color: AppColor.outlineVariant,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
      );
    }

    return _Cell(
      flex: 3,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: entries
            .map((e) => ReportRatingChip(entry: e, rating: rating))
            .toList(),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final int flex;
  final Widget child;

  const _Cell({required this.flex, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: child,
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, color: AppColor.outlineVariant.withOpacity(0.4));
  }
}
