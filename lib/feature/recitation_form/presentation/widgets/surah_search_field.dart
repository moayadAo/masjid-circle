// surah_search_field.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/typography/style_app.dart';

class SurahSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SurahSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: AppTextStyle.bodyMd(context),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColor.surfaceContainerLow,
        hintText: 'ابحث عن سورة...',
        hintStyle: AppTextStyle.bodyMd(context).copyWith(
          color: AppColor.outline,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColor.outline,
          size: AppIconSize.md.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.2),
        ),
      ),
    );
  }
}
