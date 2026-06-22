// recitations_filter_button.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class RecitationsFilterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const RecitationsFilterButton({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive
                ? AppColor.primaryContainer
                : AppColor.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive
                  ? AppColor.primaryContainer
                  : AppColor.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list_rounded,
                size: 18.sp,
                color: isActive
                    ? AppColor.onPrimaryContainer
                    : AppColor.onSurfaceVariant,
              ),
              SizedBox(width: 6.w),
              Text(
                'تصفية',
                style: AppTextStyle.labelLg(
                  context,
                  isActive
                      ? AppColor.onPrimaryContainer
                      : AppColor.onSurfaceVariant,
                  null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
