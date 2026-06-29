// report_rating_chip.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/daily_report/data/model/daily_report_model.dart';

enum ReportRating { excellent, veryGood, good }

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
  };

  Color get _fg => switch (rating) {
    ReportRating.excellent => AppColor.onTertiaryContainer,
    ReportRating.veryGood => AppColor.onSecondaryContainer,
    ReportRating.good => AppColor.onSurface,
  };

  Color get _border => switch (rating) {
    ReportRating.excellent => AppColor.tertiaryFixedDim,
    ReportRating.veryGood => AppColor.secondaryFixed,
    ReportRating.good => AppColor.outlineVariant,
  };

  IconData? get _icon => switch (rating) {
    ReportRating.excellent => Icons.verified_rounded,
    _ => null,
  };

  String _buildLabel() {
    if (entry.recitationType == 'pages' && entry.pages.isNotEmpty) {
      if (entry.pages.length == 1) return 'ص ${entry.pages.first}';
      return 'ص ${entry.pages.first}–${entry.pages.last}';
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
