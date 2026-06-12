import 'package:flutter/material.dart';
import 'package:masjid/feature/circles/data_source/model/circle_model.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleCardWidget extends StatelessWidget {
  final CircleModel circle;
  final VoidCallback onTap;

  const CircleCardWidget({
    super.key,
    required this.circle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.xl),
          left: Radius.zero,
        ),
        // circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColor.surfaceVariant),
      ),
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColor.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  bottomLeft: Radius.circular(AppRadius.xl),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            circle.name,
                            style: AppTextStyle.headlineMd(
                              context,
                            ).copyWith(color: AppColor.onSurface),
                          ),
                          if (circle.cycle != null)
                            Text(
                              circle.cycle!.name,
                              style: AppTextStyle.bodyMd(
                                context,
                              ).copyWith(color: AppColor.outline),
                            ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: circle.status),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Stats row ───────────────────────────────
                Row(
                  children: [
                    // _StatCell(
                    //   icon: Icons.group_outlined,
                    //   label: 'الطلاب',
                    //   value: circle.enrolledCount.toString(),
                    // ),
                    const SizedBox(width: AppSpacing.md),
                    _StatCell(
                      icon: Icons.menu_book_outlined,
                      label: 'النوع',
                      value: circle.category?.name ?? '—',
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Enter button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryContainer,
                      foregroundColor: AppColor.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: AppIconSize.sm),
                    label: Text(
                      'دخول للحلقة',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onPrimary,
                        null,
                      ),
                    ),
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      'active' => 'نشطة',
      'paused' => 'موقوفة',
      'archived' => 'مؤرشفة',
      _ => status,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColor.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppRadius.md), //! here was full
      ),
      child: Text(
        label,
        style: AppTextStyle.labelLg(context, AppColor.primary, null),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColor.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: AppIconSize.xs, color: AppColor.outline),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTextStyle.bodyMd(
                    context,
                  ).copyWith(color: AppColor.outline, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyle.headlineMd(
                context,
              ).copyWith(color: AppColor.primary),
            ),
          ],
        ),
      ),
    );
  }
}
