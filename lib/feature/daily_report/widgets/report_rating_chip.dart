// report_rating_chip.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

enum ReportRating { excellent, veryGood, good, failed }

class ReportRatingChip extends StatelessWidget {
  final DailyReportRecitationEntry entry;
  final ReportRating rating;

  const ReportRatingChip({
    super.key,
    required this.entry,
    required this.rating,
  });

  Color get _bg => switch (rating) {
    ReportRating.excellent => AppColor.tertiaryFixed,
    ReportRating.veryGood => AppColor.secondaryContainer,
    ReportRating.good => AppColor.surfaceContainerHigh,
    ReportRating.failed => AppColor.errorContainer,
  };

  Color get _fg => switch (rating) {
    ReportRating.excellent => AppColor.onTertiaryContainer,
    ReportRating.veryGood => AppColor.onSecondaryContainer,
    ReportRating.good => AppColor.onSurface,
    ReportRating.failed => AppColor.onErrorContainer,
  };

  Color get _border => switch (rating) {
    ReportRating.excellent => AppColor.tertiaryFixedDim,
    ReportRating.veryGood => AppColor.secondaryFixed,
    ReportRating.good => AppColor.outlineVariant,
    ReportRating.failed => AppColor.error,
  };

  IconData? get _icon => switch (rating) {
    ReportRating.excellent => Icons.verified_rounded,
    _ => null,
  };

  // ── Pages grouping logic ──────────────────────────────────
  //
  // Groups a sorted list of page numbers into consecutive runs.
  // Each run is rendered as:
  //   • Single page          → "ص 30"
  //   • Two consecutive      → "ص 37–38"
  //   • Three+ consecutive   → "ص 30–35"
  //   • Non-consecutive set  → individual entries joined by "، "
  //
  // Example inputs → outputs:
  //   [30,32,35]        → "ص 30، ص 32، ص 35"
  //   [30,31,32,33,34]  → "ص 30–34"
  //   [30,31,32,37,38]  → "ص 30–32، ص 37–38"
  String _buildPagesLabel(List<int> pages) {
    if (pages.isEmpty) return '';

    final sorted = List<int>.from(pages)..sort();
    final groups = <List<int>>[];

    // Step 1 – split into consecutive groups
    var current = [sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      if (sorted[i] == sorted[i - 1] + 1) {
        // Continues the current run
        current.add(sorted[i]);
      } else {
        // Gap found — close current run, start a new one
        groups.add(current);
        current = [sorted[i]];
      }
    }
    groups.add(current); // Close the last run

    // Step 2 – render each group
    final parts = groups.map((group) {
      if (group.length == 1) return 'ص ${group.first}';
      // Two or more consecutive pages: show range
      return 'ص ${group.first}–${group.last}';
    });

    return parts.join('، ');
  }

  String _buildLabel() {
    if (entry.recitationType == 'pages' && entry.pages.isNotEmpty) {
      return _buildPagesLabel(entry.pages);
    }
    if (entry.recitationType == 'surah' && entry.surahs.isNotEmpty) {
      return entry.surahs.map((s) => s.nameArabic).join('، ');
    }
    if (entry.recitationType == 'ayah_range' && entry.ayahRanges.isNotEmpty) {
      final r = entry.ayahRanges.first;
      return '${r.surahNameArabic} (${r.fromAyah}–${r.toAyah})';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final label = _buildLabel();
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_icon != null) ...[
            Icon(_icon, size: 13, color: _fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTextStyle.labelLg(context, _fg, 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
