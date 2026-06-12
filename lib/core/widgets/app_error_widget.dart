import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';

// ─── AppErrorWidget ───────────────────────────────────────────────────────────

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final double? height;

  const AppErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE74C3C).withOpacity(0.95),
            const Color(0xFFC0392B).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE74C3C).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Error Icon ─────────────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 48.sp,
            ),
          ),

          SizedBox(height: 16.h),

          // ── Error Message ──────────────────────────────────────────────────────
          Text(
            'خطأ',
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyLg(
              context,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8.h),

          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyMd(
                context,
              ).copyWith(color: Colors.white.withOpacity(0.9), height: 1.5),
            ),
          ),

          SizedBox(height: 24.h),

          // ── Retry Button ───────────────────────────────────────────────────────
          InkWell(
            onTap: onRetry,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    color: const Color(0xFFE74C3C),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'إعادة محاولة',
                    style: AppTextStyle.bodyMd(context).copyWith(
                      color: const Color(0xFFE74C3C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
