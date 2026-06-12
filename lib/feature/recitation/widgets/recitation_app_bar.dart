// general_recitation_app_bar.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class RecitationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RecitationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.primary, AppColor.primaryContainer],
        ),
      ),
      child: SafeArea(
        bottom: false,
        // Layout is fixed left-to-right (icon - title - back arrow)
        // regardless of the app's RTL direction, to match the design.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              CircleAvatar(
                radius: AppIconSize.md.r,
                backgroundColor: AppColor.onPrimary.withOpacity(0.12),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColor.onPrimary,
                  size: AppIconSize.md.sp,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Quran Progress',
                    style: AppTextStyle.headlineMd(context).copyWith(
                      color: AppColor.onPrimary,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColor.onPrimary,
                  size: AppIconSize.md.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}
