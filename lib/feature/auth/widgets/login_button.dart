import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/spacing_system/icon_sizes.dart';
import 'package:masjid/core/design_app/spacing_system/radius.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/design_app/spacing_system/spacing.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryContainer,
          foregroundColor: AppColor.onPrimary,
          disabledBackgroundColor: AppColor.primaryContainer.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColor.onPrimary,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: AppTextStyle.labelLg(
                      context,
                      AppColor.onPrimary,
                      16,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.login, size: AppIconSize.sm),
                ],
              ),
      ),
    );
  }
}
