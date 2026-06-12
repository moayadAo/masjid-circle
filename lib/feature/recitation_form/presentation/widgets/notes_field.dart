// notes_field.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';

class NotesField extends StatelessWidget {
  final TextEditingController controller;

  const NotesField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظات (اختياري)',
          style: AppTextStyle.labelLg(context, null, 14.sp),
        ),
        AppSpacing.sm.sbH,
        TextField(
          controller: controller,
          maxLines: 3,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.bodyMd(context),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'أضف ملاحظات حول التسميع...',
            hintStyle: AppTextStyle.bodyMd(context).copyWith(
              color: AppColor.outline,
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: const BorderSide(color: AppColor.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: const BorderSide(color: AppColor.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
