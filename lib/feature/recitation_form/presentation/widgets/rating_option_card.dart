// rating_option_card.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';

class RatingOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const RatingOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppIconSize.lg.r,
              backgroundColor:
                  isSelected ? AppColor.onPrimary : AppColor.surfaceContainerLow,
              child: Icon(
                icon,
                color: isSelected ? AppColor.primary : AppColor.outline,
                size: AppIconSize.md.sp,
              ),
            ),
            AppSpacing.xs.sbH,
            Text(
              label,
              style: AppTextStyle.labelLg(
                context,
                isSelected ? AppColor.onPrimary : AppColor.outline,
                13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
