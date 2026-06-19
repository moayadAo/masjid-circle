import 'package:flutter/material.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceHeaderWidget extends StatelessWidget {
  final AttendanceSessionModel session;

  const AttendanceHeaderWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Wrapped the left side in Expanded so it adapts to smaller screens
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Keeps the column tight vertically
              children: [
                Text(
                  session.openedBy.name,
                  style: AppTextStyle.bodyMd(
                    context,
                  ).copyWith(color: AppColor.outline),
                  maxLines:
                      1, // Prevents text from breaking into multiple lines awkwardly
                  overflow: TextOverflow
                      .ellipsis, // Adds '...' if the name is way too long
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  session.date,
                  style: AppTextStyle.headlineMd(
                    context,
                  ).copyWith(color: AppColor.primary, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 2. Added a small gap so the text never touches the container
          const SizedBox(width: AppSpacing.md),

          // 3. Right side (Total Students Counter) remains fixed
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColor.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إجمالي الطلاب',
                  style: AppTextStyle.labelLg(context, AppColor.outline, 11),
                ),
                Text(
                  '${session.records.length}',
                  style: AppTextStyle.headlineMd(
                    context,
                  ).copyWith(color: AppColor.primary, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
