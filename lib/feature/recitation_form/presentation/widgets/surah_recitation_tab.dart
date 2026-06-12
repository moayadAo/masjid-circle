// surah_recitation_tab.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';
import '../../data/models/surah_model.dart';

class SurahRecitationTab extends StatelessWidget {
  final SurahModel? selectedSurah;
  final VoidCallback onTap;

  const SurahRecitationTab({
    super.key,
    required this.selectedSurah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.md.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColor.outline,
              size: AppIconSize.md.sp,
            ),
            Expanded(
              child: Text(
                selectedSurah?.nameAr ?? 'اختر السورة',
                textAlign: TextAlign.center,
                style: AppTextStyle.labelLg(
                  context,
                  selectedSurah == null ? AppColor.outline : null,
                  15.sp,
                ),
              ),
            ),
            Icon(
              Icons.menu_book_rounded,
              color: AppColor.secondary,
              size: AppIconSize.md.sp,
            ),
          ],
        ),
      ),
    );
  }
}
