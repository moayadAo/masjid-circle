// surah_grid_item.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';
import '../../data/models/surah_model.dart';

class SurahGridItem extends StatelessWidget {
  final SurahModel surah;
  final bool isSelected;
  final VoidCallback onTap;

  const SurahGridItem({
    super.key,
    required this.surah,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.secondaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(
            color: isSelected ? AppColor.secondary : AppColor.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppIconSize.md.r,
              backgroundColor: isSelected
                  ? AppColor.primary
                  : AppColor.surfaceContainerLow,
              child: Text(
                '${surah.id}',
                style: AppTextStyle.labelLg(
                  context,
                  isSelected ? AppColor.onPrimary : AppColor.outline,
                  14.sp,
                ),
              ),
            ),
            AppSpacing.md.sbH,
            Text(
              surah.nameAr,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.labelLg(
                context,
                isSelected ? AppColor.primary : null,
                18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
