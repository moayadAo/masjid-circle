// student_info_card.dart
//
// Generic card shell used by all three info sections:
// Personal Info, Guardian Info, Contact Info.
// The accent strip on the right edge uses a customisable color.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:url_launcher/url_launcher.dart';

/// A phone row with a call button.
class PhoneRow extends StatelessWidget {
  final String label;
  final String phone;

  const PhoneRow({super.key, required this.label, required this.phone});

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  //   await launchUrl(launchUri);
  // }
  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    // 1. Sanitization: Remove everything except numbers and '+'
    final String cleanedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    final Uri launchUri = Uri(scheme: 'tel', path: cleanedPhone);

    // 2. Safety: Check if the device can handle the URL
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // 3. Fallback: Notify the user if the action cannot be performed
      if (context.mounted) {
        AppToast.error(context, 'لا يمكن فتح تطبيق الاتصال على هذا الجهاز.');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Could not launch the dialer.'),
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.labelLg(context, AppColor.outline, 11),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyle.bodyMd(
                    context,
                  ).copyWith(color: AppColor.onSurface, fontSize: 14),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _makePhoneCall(
              context,
              phone,
            ), // caller wires up url_launcher if needed
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call_rounded,
                size: AppIconSize.sm,
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
