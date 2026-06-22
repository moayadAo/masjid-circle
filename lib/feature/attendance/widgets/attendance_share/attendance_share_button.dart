// attendance_share_button.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import './attendance_share_controller.dart';

class AttendanceShareButton extends StatefulWidget {
  final AttendanceSessionModel session;

  const AttendanceShareButton({super.key, required this.session});

  @override
  State<AttendanceShareButton> createState() => _AttendanceShareButtonState();
}

class _AttendanceShareButtonState extends State<AttendanceShareButton> {
  bool _isSharing = false;

  Future<void> _handleShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    final success = await AttendanceShareController.captureAndShare(
      context: context,
      session: widget.session,
    );

    if (!mounted) return;
    setState(() => _isSharing = false);

    if (!success) {
      AppToast.error(context, 'تعذرت مشاركة سجل الحضور، حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleShare,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.primaryContainer.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.primaryContainer.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: _isSharing
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primary,
                  ),
                )
              : const Icon(
                  Icons.ios_share_rounded,
                  color: AppColor.primary,
                  size: AppIconSize.sm,
                ),
        ),
      ),
    );
  }
}
