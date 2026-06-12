// or_divider.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.border, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
          child: Text(
            'أو',
            style: AppTextStyle.bodyMd(context).copyWith(
              color: AppColor.outline,
              fontSize: 13.sp,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColor.border, thickness: 1)),
      ],
    );
  }
}
