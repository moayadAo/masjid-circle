import 'package:flutter/material.dart';
import 'package:masjid/feature/circles/data_source/model/circle_student_model.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class StudentListItemWidget extends StatelessWidget {
  final CircleStudentModel student;
  final VoidCallback? onTap;

  const StudentListItemWidget({super.key, required this.student, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
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
        child: Row(
          children: [
            // Avatar
            _StudentAvatar(
              letter: student.avatarLetter,
              status: student.status,
            ),
            const SizedBox(width: AppSpacing.md),

            // Name + code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: AppTextStyle.headlineMd(
                      context,
                    ).copyWith(color: AppColor.primary, fontSize: 16),
                  ),
                  Text(
                    student.publicCode,
                    style: AppTextStyle.bodyMd(
                      context,
                    ).copyWith(color: AppColor.outline, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Status badge
            _StudentStatusBadge(status: student.status),
            const SizedBox(width: AppSpacing.sm),

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: AppColor.outline,
              size: AppIconSize.md,
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  final String letter;
  final String status;
  const _StudentAvatar({required this.letter, required this.status});

  Color get _bgColor {
    return switch (status) {
      'active' => AppColor.primaryFixed,
      'inactive' => AppColor.surfaceVariant,
      'archived' => AppColor.errorContainer,
      _ => AppColor.surfaceVariant,
    };
  }

  Color get _textColor {
    return switch (status) {
      'active' => AppColor.primary,
      'inactive' => AppColor.outline,
      'archived' => AppColor.error,
      _ => AppColor.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: _bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTextStyle.headlineMd(
          context,
        ).copyWith(color: _textColor, fontSize: 20),
      ),
    );
  }
}

class _StudentStatusBadge extends StatelessWidget {
  final String status;
  const _StudentStatusBadge({required this.status});

  (String, Color, Color) get _config {
    return switch (status) {
      'active' => ('نشط', AppColor.secondaryContainer, AppColor.secondary),
      'inactive' => ('غير نشط', AppColor.surfaceVariant, AppColor.outline),
      'archived' => ('مؤرشف', AppColor.surfaceVariant, AppColor.outline),
      _ => (status, AppColor.surfaceVariant, AppColor.outline),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (label, bg, text) = _config;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md), //! here was full
      ),
      child: Text(label, style: AppTextStyle.labelLg(context, text, null)),
    );
  }
}
