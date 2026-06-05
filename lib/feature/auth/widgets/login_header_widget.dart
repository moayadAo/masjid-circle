import 'package:flutter/material.dart';
import 'package:masjid/core/constant/assets_manager.dart';
import 'package:masjid/core/design_app/spacing_system/radius.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/design_app/spacing_system/spacing.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Mosque image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
          child: Image.asset(
            AssetsManager.headerImageLogin,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(height: 200, color: AppColor.primaryContainer),
          ),
        ),
        // Dark gradient overlay
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xl),
              topRight: Radius.circular(AppRadius.xl),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primary.withOpacity(0.3),
                AppColor.primary.withOpacity(0.85),
              ],
            ),
          ),
        ),
        // Text
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نور على نور',
                style: AppTextStyle.headlineLg(
                  context,
                ).copyWith(color: AppColor.onPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'نظام إدارة الحلقات القرآنية. يسر وسهولة في متابعة الحفظ والمراجعة.',
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: AppColor.onPrimaryContainer),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
