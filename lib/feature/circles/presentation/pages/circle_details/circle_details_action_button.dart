import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleDetailsActionButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const CircleDetailsActionButton({
    super.key,
    required this.isVisible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColor.primaryContainer,
      foregroundColor: AppColor.onPrimary,
      icon: const Icon(Icons.add),
      label: Text(
        'إضافة جلسة حضور',
        style: AppTextStyle.labelLg(context, AppColor.onPrimary, null),
      ),
    );
  }
}
