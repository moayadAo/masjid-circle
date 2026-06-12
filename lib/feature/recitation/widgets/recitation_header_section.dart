// recitation_header_section.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class RecitationHeaderSection extends StatelessWidget {
  const RecitationHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تسميع عام',
          style: AppTextStyle.headlineMd(context).copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w700,
            fontSize: 24.sp,
          ),
        ),
        AppSpacing.xs.sbH,
        Text(
          'قم بمسح رمز الطالب أو إدخال رقمه للبدء',
          style: AppTextStyle.bodyMd(context).copyWith(
            color: AppColor.outline,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
