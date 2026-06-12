import 'package:flutter/material.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceSessionCardWidget extends StatelessWidget {
  final AttendanceSessionModel session;
  final VoidCallback onTap;

  const AttendanceSessionCardWidget({
    super.key,
    required this.session,
    required this.onTap,
  });

  Color get _accentColor {
    return switch (session.status) {
      'submitted' => AppColor.primaryContainer,
      'draft' => AppColor.tertiary,
      'locked' => AppColor.outline,
      _ => AppColor.outline,
    };
  }

  (String, Color, Color) get _badgeConfig {
    return switch (session.status) {
      'submitted' => (
        'تم التسليم',
        AppColor.secondaryContainer,
        AppColor.secondary,
      ),
      'draft' => (
        'مسودة',
        AppColor.tertiaryContainer,
        AppColor.onTertiaryContainer,
      ),
      'locked' => ('مقفلة', AppColor.surfaceVariant, AppColor.outline),
      _ => (session.statusLabel, AppColor.surfaceVariant, AppColor.outline),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (badgeLabel, badgeBg, badgeText) = _badgeConfig;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border(right: BorderSide(color: _accentColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '#${session.id}',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.primary,
                        null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
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
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(
                      AppRadius.md,
                    ), //! here was full
                  ),
                  child: Text(
                    badgeLabel,
                    style: AppTextStyle.labelLg(context, badgeText, null),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Meta row ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _MetaItem(
                    icon: Icons.person_outline,
                    text: session.openedBy.name,
                  ),
                ),
                Expanded(
                  child: _MetaItem(
                    icon: Icons.groups_outlined,
                    text:
                        '${session.recordsCount ?? session.records.length} طلاب',
                  ),
                ),
              ],
            ),

            // ── Notes ─────────────────────────────────────────
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const Divider(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.notes_outlined,
                    size: AppIconSize.sm,
                    color: AppColor.outline,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      session.notes!,
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.outline,
                        null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.sm, color: AppColor.outline),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: AppTextStyle.bodyMd(
              context,
            ).copyWith(color: AppColor.outline),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
