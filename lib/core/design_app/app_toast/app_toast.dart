import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';

// ─── Toast Types ──────────────────────────────────────────────────────────────

enum AppToastType { success, error, warning, info }

// ─── AppToast ─────────────────────────────────────────────────────────────────

class AppToast {
  AppToast._();
  static OverlayEntry? _currentEntry;
  // ── Public API ───────────────────────────────────────────────────────────────

  static void success(BuildContext context, String message) =>
      _show(context, message, AppToastType.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, AppToastType.error);

  static void warning(BuildContext context, String message) =>
      _show(context, message, AppToastType.warning);

  static void info(BuildContext context, String message) =>
      _show(context, message, AppToastType.info);

  // ── Core ──────────────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context,
    String message,
    AppToastType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    // إزالة التنبيه السابق إن وجد
    _currentEntry?.remove();

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.h, // سيظهر من الأعلى ليكون مرئياً فوق الـ Bottom Sheet
        left: 20.w,
        right: 20.w,
        child: Material(
          color: Colors.transparent,
          child: _ToastContent(message: message, type: type),
        ),
      ),
    );

    // استخدام Overlay.of(context) لضمان الظهور فوق الـ Modal
    Overlay.of(context).insert(_currentEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _currentEntry?.remove();
      _currentEntry = null;
    });

    // final messenger = scaffoldMessengerKey.currentState;

    // messenger!.hideCurrentSnackBar();
    // messenger.showSnackBar(
    //   SnackBar(
    //     content: _ToastContent(message: message, type: type),
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     behavior: SnackBarBehavior.floating,
    //     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    //     padding: EdgeInsets.zero,
    //     duration: duration,
    //     dismissDirection: DismissDirection.horizontal,
    //   ),
    // );

    // final messenger = ScaffoldMessenger.of(context);
  }
}

// ─── Toast Content Widget ─────────────────────────────────────────────────────

class _ToastContent extends StatelessWidget {
  final String message;
  final AppToastType type;

  const _ToastContent({required this.message, required this.type});

  // ── Config per type ───────────────────────────────────────────────────────────

  Color get _backgroundColor {
    return switch (type) {
      AppToastType.success => const Color(0xFF2ECC71),
      AppToastType.error => const Color(0xFFE74C3C),
      AppToastType.warning => const Color(0xFFF39C12),
      AppToastType.info => const Color(0xFF2980B9),
    };
  }

  IconData get _icon {
    return switch (type) {
      AppToastType.success => Icons.check_circle_outline_rounded,
      AppToastType.error => Icons.cancel_outlined,
      AppToastType.warning => Icons.warning_amber_rounded,
      AppToastType.info => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: _backgroundColor.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الإغلاق
          // GestureDetector(
          //   onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          //   child: Icon(Icons.close, color: Colors.white, size: 18.sp),
          // ),

          // النص
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyMd(context).copyWith(color: Colors.white),
            ),
          ),

          SizedBox(width: 10.w),

          // الأيقونة
          Icon(_icon, color: Colors.white, size: 22.sp),
        ],
      ),
    );
  }
}
