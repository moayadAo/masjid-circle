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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المعلم: ${session.openedBy.name}',
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: AppColor.outline),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                session.date,
                style: AppTextStyle.headlineMd(
                  context,
                ).copyWith(color: AppColor.primary, fontSize: 16),
              ),
            ],
          ),
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
