import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String circleName;

  const CircleDetailsAppBar({super.key, required this.circleName});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.surfaceContainerLowest,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        circleName,
        style: AppTextStyle.headlineMd(
          context,
        ).copyWith(color: AppColor.primary),
      ),
    );
  }
}
