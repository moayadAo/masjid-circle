import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

/// Placeholder page for assistant teacher role.
/// TODO: implement QR scan + student search + recitation recording.
class AssistantHomePage extends StatelessWidget {
  const AssistantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.surfaceContainerLowest,
          elevation: 0,
          title: Text(
            'التسميع',
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primary),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: AppColor.primaryContainer,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'صفحة المعلم المساعد',
                style: AppTextStyle.headlineMd(
                  context,
                ).copyWith(color: AppColor.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'امسح رمز QR أو ابحث بكود الطالب',
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: AppColor.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
