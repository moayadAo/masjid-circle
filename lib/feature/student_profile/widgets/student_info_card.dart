// student_info_card.dart
//
// Generic card shell used by all three info sections:
// Personal Info, Guardian Info, Contact Info.
// The accent strip on the right edge uses a customisable color.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class StudentInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;
  final Color iconBg;
  final Color iconFg;
  final List<Widget> children;

  const StudentInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.iconBg,
    required this.iconFg,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accent strip
              Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: iconBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: iconFg,
                              size: AppIconSize.sm,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            title,
                            style: AppTextStyle.headlineMd(
                              context,
                            ).copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...children,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
