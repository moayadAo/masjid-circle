// student_profile_header.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_detail_model.dart';

class StudentProfileHeader extends StatelessWidget {
  final StudentDetailModel student;
  final VoidCallback? onRecitationTap;

  const StudentProfileHeader({
    super.key,
    required this.student,
    this.onRecitationTap,
  });

  Color get _statusBg => switch (student.status) {
    'active' => AppColor.secondaryContainer,
    'inactive' => AppColor.surfaceVariant,
    _ => AppColor.errorContainer,
  };

  Color get _statusFg => switch (student.status) {
    'active' => AppColor.secondary,
    'inactive' => AppColor.outline,
    _ => AppColor.error,
  };

  Color get _avatarBg => switch (student.status) {
    'active' => AppColor.primaryFixed,
    'inactive' => AppColor.surfaceVariant,
    _ => AppColor.errorContainer,
  };

  Color get _avatarFg => switch (student.status) {
    'active' => AppColor.primary,
    'inactive' => AppColor.outline,
    _ => AppColor.error,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Avatar ───────────────────────────────────────
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _avatarBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.primaryContainer.withOpacity(0.2),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              student.avatarLetter,
              style: AppTextStyle.headlineMd(
                context,
              ).copyWith(color: _avatarFg, fontSize: 28),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // ── Name + code + status ─────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: AppTextStyle.headlineMd(
                    context,
                  ).copyWith(color: AppColor.onSurface, fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: AppIconSize.xs,
                      color: AppColor.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      student.publicCode,
                      style: AppTextStyle.bodyMd(
                        context,
                      ).copyWith(color: AppColor.outline, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    student.statusLabel,
                    style: AppTextStyle.labelLg(context, _statusFg, 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
