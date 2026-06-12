import 'package:flutter/material.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceRecordRowWidget extends StatelessWidget {
  final AttendanceRecordModel record;
  final ValueChanged<String> onStatusChanged;

  const AttendanceRecordRowWidget({
    super.key,
    required this.record,
    required this.onStatusChanged,
  });

  static const _statuses = ['present', 'absent', 'late', 'excused'];
  static const _icons = [
    Icons.check_circle_outline,
    Icons.cancel_outlined,
    Icons.schedule_outlined,
    Icons.history_outlined,
  ];

  static Color _activeColor(String status) {
    return switch (status) {
      'present' => AppColor.hadir,
      'absent' => AppColor.absent,
      'late' => AppColor.late,
      'excused' => AppColor.excused,
      _ => AppColor.surfaceVariant,
    };
  }

  static Color _activeIconColor(String status) {
    return switch (status) {
      'present' => const Color(0xFF166534),
      'absent' => const Color(0xFF991B1B),
      'late' => const Color(0xFF92400E),
      'excused' => const Color(0xFF1E40AF),
      _ => AppColor.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Avatar + name ─────────────────────────────────
          Expanded(
            flex: 4,
            child: Row(
              children: [
                _Avatar(letter: record.student.avatarLetter),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    record.student.fullName,
                    style: AppTextStyle.bodyMd(
                      context,
                    ).copyWith(color: AppColor.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ── Status buttons ────────────────────────────────
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (i) {
                final s = _statuses[i];
                final isSelected = record.status == s;
                return _StatusButton(
                  icon: _icons[i],
                  isSelected: isSelected,
                  activeColor: _activeColor(s),
                  activeIconColor: _activeIconColor(s),
                  onTap: () => onStatusChanged(s),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String letter;
  const _Avatar({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTextStyle.bodyMd(
          context,
        ).copyWith(color: AppColor.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final Color activeIconColor;
  final VoidCallback onTap;

  const _StatusButton({
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.activeIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? activeColor : AppColor.surfaceContainerLow,
          border: Border.all(
            color: isSelected
                ? activeIconColor.withOpacity(0.4)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: AppIconSize.sm,
          color: isSelected ? activeIconColor : AppColor.outline,
        ),
      ),
    );
  }
}
