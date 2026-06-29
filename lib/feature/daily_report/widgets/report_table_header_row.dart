// report_table_header_row.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class ReportTableHeaderRow extends StatelessWidget {
  const ReportTableHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: AppColor.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          _HeaderCell(label: 'اسم الطالب', flex: 3, isPrimary: true),
          _VertDivider(),
          _HeaderCell(label: 'ممتاز', flex: 3, icon: Icons.workspace_premium_rounded),
          _VertDivider(),
          _HeaderCell(label: 'جيد جداً', flex: 3),
          _VertDivider(),
          _HeaderCell(label: 'جيد', flex: 3),
          _VertDivider(),
          _HeaderCell(label: 'آخر تسميع', flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final bool isPrimary;
  final IconData? icon;

  const _HeaderCell({
    required this.label,
    required this.flex,
    this.isPrimary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColor.tertiaryContainer),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTextStyle.labelLg(
                  context,
                  isPrimary ? AppColor.primaryContainer : AppColor.onSurfaceVariant,
                  11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColor.outlineVariant.withOpacity(0.4),
    );
  }
}
