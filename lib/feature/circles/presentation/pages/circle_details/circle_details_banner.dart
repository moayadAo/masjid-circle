import 'package:flutter/material.dart';
import 'package:masjid/core/constant/assets_manager.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleDetailsBanner extends StatelessWidget {
  const CircleDetailsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetsManager.heroImageCircleDetails,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(height: 160, color: AppColor.primaryContainer),
        ),
        Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primary.withOpacity(0.2),
                AppColor.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.md,
          right: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الحلقة',
                style: AppTextStyle.headlineLg(
                  context,
                ).copyWith(color: AppColor.onPrimary),
              ),
              Text(
                'إدارة حضور الطلاب',
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: AppColor.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
