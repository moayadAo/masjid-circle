// student_info_card.dart
//
// Generic card shell used by all three info sections:
// Personal Info, Guardian Info, Contact Info.
// The accent strip on the right edge uses a customisable color.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/student_profile/widgets/student_info_card.dart';

/// A single labeled row inside a [StudentInfoCard].
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  value,
                  style: AppTextStyle.bodyMd(
                    context,
                  ).copyWith(color: AppColor.onSurface, fontSize: 14),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
