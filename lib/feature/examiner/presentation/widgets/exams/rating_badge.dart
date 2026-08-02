import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

import '../../../data/models/juz_exam_model.dart';

class RatingBadge extends StatelessWidget {
  final JuzExamRating rating;

  const RatingBadge({super.key, required this.rating});

  ({Color bg, Color fg, IconData icon}) get _config {
    switch (rating) {
      case JuzExamRating.excellent:
        return (
          bg: AppColor.secondaryContainer,
          fg: AppColor.onSecondaryContainer,
          icon: Icons.stars_rounded,
        );
      case JuzExamRating.veryGood:
        return (
          bg: AppColor.tertiaryFixed,
          fg: AppColor.onTertiaryFixedVariant,
          icon: Icons.thumb_up_rounded,
        );
      case JuzExamRating.good:
        return (
          bg: AppColor.surfaceContainerHighest,
          fg: AppColor.onSurfaceVariant,
          icon: Icons.check_circle_rounded,
        );
      case JuzExamRating.failed:
        return (
          bg: AppColor.errorContainer,
          fg: AppColor.error,
          icon: Icons.cancel_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _config;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(c.icon, size: 15.sp, color: c.fg),
          4.sbW,
          Text(
            rating.arabicLabel,
            style: AppTextStyle.labelLg(context, c.fg, 13),
          ),
        ],
      ),
    );
  }
}
