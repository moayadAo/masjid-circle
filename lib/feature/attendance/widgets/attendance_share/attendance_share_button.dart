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

  Future<void> _handleShare({required bool includeText}) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    final success = await AttendanceShareController.captureAndShare(
      context: context,
      session: widget.session,
      includeStudentDetails: includeText,
    );

    if (!mounted) return;
    setState(() => _isSharing = false);

    if (!success) {
      AppToast.error(context, 'تعذرت مشاركة سجل الحضور، حاول مرة أخرى');
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختر طريقة المشاركة',
              style: AppTextStyle.headlineMd(
                context,
              ).copyWith(color: AppColor.onBackground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _ShareOptionButton(
              icon: Icons.image_outlined,
              title: 'جدول فقط',
              description: 'مشاركة صورة الجدول فقط',
              onTap: () {
                Navigator.pop(context);
                _handleShare(includeText: false);
              },
            ),
            const SizedBox(height: 12),
            _ShareOptionButton(
              icon: Icons.info_outline,
              title: 'جدول مع التفاصيل',
              description: 'مشاركة الجدول مع أسماء الطلاب والحالة',
              onTap: () {
                Navigator.pop(context);
                _handleShare(includeText: true);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showShareOptions,
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

class _ShareOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ShareOptionButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.outlineVariant,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColor.primary, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.labelLg(context, AppColor.onBackground, null),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyle.bodyMd(context).copyWith(color: AppColor.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
