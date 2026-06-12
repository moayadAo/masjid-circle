// page_counter_field.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';

class PageCounterField extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PageCounterField({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Counter control: keep (- value +) order regardless of locale.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CounterButton(icon: Icons.remove_rounded, onTap: onDecrement),
              Container(
                width: 56.w,
                height: 36.h,
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  border: Border.all(color: AppColor.border),
                ),
                child: Text(
                  '$value',
                  style: AppTextStyle.labelLg(context, null, 16.sp),
                ),
              ),
              _CounterButton(icon: Icons.add_rounded, onTap: onIncrement),
            ],
          ),
        ),
        Text(
          label,
          style: AppTextStyle.labelLg(context, null, 15.sp),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: Container(
        width: 36.w,
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
        ),
        child: Icon(icon, color: AppColor.onPrimary, size: AppIconSize.sm.sp),
      ),
    );
  }
}
