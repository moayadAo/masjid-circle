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
    // Close button stays on the physical left, text block on the right,
    // regardless of the app's text direction (matches the design).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.close_rounded,
              color: AppColor.outline,
              size: AppIconSize.md.sp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  studentName,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.headlineMd(context).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                AppSpacing.xs.sbH,
                Text(
                  'تسجيل تسميع جديد',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.bodyMd(context).copyWith(
                    color: AppColor.outline,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
