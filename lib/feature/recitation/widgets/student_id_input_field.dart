// student_id_input_field.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/radius.dart';
import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class StudentIdInputField extends StatelessWidget {
  final TextEditingController controller;

  const StudentIdInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم الطالب',
          style: AppTextStyle.labelLg(
            context,
            null,
            14.sp,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        AppSpacing.sm.sbH,
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.bodyMd(context),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'أدخل رقم الطالب هنا...',
            hintStyle: AppTextStyle.bodyMd(
              context,
            ).copyWith(color: AppColor.outline, fontSize: 14.sp),
            // suffixIcon: Padding(
            //   padding: EdgeInsets.all(AppSpacing.xs.r),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: AppSpacing.xs.w,
            //       vertical: AppSpacing.xs.h,
            //     ),
            //     decoration: BoxDecoration(
            //       color: AppColor.surfaceVariant,
            //       borderRadius: BorderRadius.circular(AppRadius.xs.r),
            //     ),
            //     child: Text(
            //       '123',
            //       style: AppTextStyle.bodyMd(context).copyWith(
            //         color: AppColor.outline,
            //         fontSize: 11.sp,
            //       ),
            //     ),
            //   ),
            // ),
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
