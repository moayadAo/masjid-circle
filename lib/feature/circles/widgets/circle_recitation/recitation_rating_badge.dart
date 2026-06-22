// recitation_rating_badge.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class RecitationRatingBadge extends StatelessWidget {
  final String rating; // good | very_good | excellent

  const RecitationRatingBadge({super.key, required this.rating});

  String get _label {
    switch (rating) {
      case 'excellent':
        return 'ممتاز';
      case 'very_good':
        return 'جيد جداً';
      default:
        return 'جيد';
    }
  }

  Color get _background {
    switch (rating) {
      case 'excellent':
        return AppColor.tertiaryContainer;
      case 'very_good':
        return AppColor.secondaryContainer;
      default:
        return AppColor.surfaceContainerHigh;
    }
  }

  Color get _foreground {
    switch (rating) {
      case 'excellent':
        return AppColor.onTertiary;
      case 'very_good':
        return AppColor.onSecondaryContainer;
      default:
        return AppColor.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        _label,
        style: AppTextStyle.labelLg(context, _foreground, null),
      ),
    );
  }
}
