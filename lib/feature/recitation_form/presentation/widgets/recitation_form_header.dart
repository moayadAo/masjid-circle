// recitation_form_header.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';

class RecitationFormHeader extends StatelessWidget {
  final String studentName;
  final VoidCallback onClose;

  const RecitationFormHeader({
    super.key,
    required this.studentName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.only(top: AppSpacing.xs.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColor.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColor.outlineVariant),
                ),
                child: IconButton(
                  onPressed: onClose,
                  padding: EdgeInsets.all(10.w),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColor.onSurface,
                    size: AppIconSize.md.sp,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      studentName,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.headlineMd(
                        context,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.xs.sbH,
                    Text(
                      'تسجيل تسميع جديد',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.bodyMd(
                        context,
                      ).copyWith(color: AppColor.outline, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
