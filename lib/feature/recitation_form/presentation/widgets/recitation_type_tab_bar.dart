// recitation_type_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';
import '../cubit/recitation_form_state.dart';

class RecitationTypeTabBar extends StatelessWidget {
  final RecitationFormTab selectedTab;
  final ValueChanged<RecitationFormTab> onChanged;

  const RecitationTypeTabBar({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs.r),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'سور',
              isSelected: selectedTab == RecitationFormTab.surah,
              onTap: () => onChanged(RecitationFormTab.surah),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'صفحات',
              isSelected: selectedTab == RecitationFormTab.pages,
              onTap: () => onChanged(RecitationFormTab.pages),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.outline.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.labelLg(
              context,
              isSelected ? AppColor.primary : AppColor.outline,
              14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
