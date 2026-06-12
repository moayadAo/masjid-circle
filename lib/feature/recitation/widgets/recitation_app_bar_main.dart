// general_recitation_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/widgets/logout_confirm_dialog.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';

import '../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';

class RecitationAppBarMain extends StatefulWidget
    implements PreferredSizeWidget {
  const RecitationAppBarMain({super.key});
  @override
  Size get preferredSize => Size.fromHeight(64.h);
  @override
  State<RecitationAppBarMain> createState() => _RecitationAppBarMainState();
}

class _RecitationAppBarMainState extends State<RecitationAppBarMain> {
  Future<void> _handleLogoutPressed() async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!mounted || !shouldLogout) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.primary, AppColor.primaryContainer],
        ),
      ),
      child: SafeArea(
        bottom: false,
        // Layout is fixed left-to-right (icon - title - back arrow)
        // regardless of the app's RTL direction, to match the design.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              // IconButton(
              //   icon: const Icon(
              //     Icons.logout,
              //     color: AppColor.surfaceBright,
              //     size: AppIconSize.md,
              //   ),
              //   onPressed: _handleLogoutPressed,
              // ),
              Expanded(
                child: Center(
                  child: Text(
                    'تسميع',
                    style: AppTextStyle.headlineMd(
                      context,
                    ).copyWith(color: AppColor.onPrimary),
                  ),
                ),
              ),
              CircleAvatar(
                radius: AppIconSize.md.r,
                backgroundColor: AppColor.onPrimary.withOpacity(0.0),
                child: Icon(
                  Icons.person_2_outlined,
                  color: AppColor.onPrimary,
                  size: AppIconSize.md.sp,
                ),
              ),
              // IconButton(
              //   onPressed: () => Navigator.maybePop(context),
              //   icon: Icon(
              //     Icons.arrow_forward_rounded,
              //     color: AppColor.onPrimary,
              //     size: AppIconSize.md.sp,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
