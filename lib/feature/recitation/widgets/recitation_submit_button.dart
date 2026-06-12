// recitation_submit_button.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../core/design_app/spacing_system/radius.dart';
import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class RecitationSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const RecitationSubmitButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.onPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'إرسال',
                    style: AppTextStyle.labelLg(context, AppColor.onPrimary, 16.sp)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  AppSpacing.sm.sbW,
                  Icon(
                    Icons.arrow_back_rounded,
                    color: AppColor.onPrimary,
                    size: AppIconSize.sm.sp,
                  ),
                ],
              ),
      ),
    );
  }
}
