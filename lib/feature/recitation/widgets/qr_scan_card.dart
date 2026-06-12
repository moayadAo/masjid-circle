// qr_scan_card.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../core/design_app/spacing_system/radius.dart';
import '../../../core/design_app/spacing_system/spacing.dart';
import '../../../core/design_app/typography/style_app.dart';
import '../presentation/pages/qr_scanner_page.dart';

class QrScanCard extends StatelessWidget {
  final ValueChanged<String> onCodeScanned;

  const QrScanCard({super.key, required this.onCodeScanned});

  Future<void> _openScanner(BuildContext context) async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );
    if (code != null && code.isNotEmpty) {
      onCodeScanned(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openScanner(context),
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      child: CustomPaint(
        painter: _ViewfinderBorderPainter(
          dashColor: AppColor.border,
          cornerColor: AppColor.secondary,
          radius: AppRadius.lg.r,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
          decoration: BoxDecoration(
            color: AppColor.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_2_rounded,
                size: 72.sp,
                color: AppColor.secondary,
              ),
              AppSpacing.md.sbH,
              Text(
                'مسح رمز الطالب',
                style: AppTextStyle.labelLg(context, AppColor.secondary, 16.sp)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a dashed rounded-rect border with accented corner brackets,
/// like a camera viewfinder.
class _ViewfinderBorderPainter extends CustomPainter {
  final Color dashColor;
  final Color cornerColor;
  final double radius;

  _ViewfinderBorderPainter({
    required this.dashColor,
    required this.cornerColor,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    // Dashed background border.
    final dashPaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()..addRRect(rrect);
    _drawDashedPath(canvas, path, dashPaint, dashWidth: 6, gapWidth: 4);

    // Corner brackets.
    final cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const len = 18.0;
    final w = size.width;
    final h = size.height;
    final r = radius;

    final corners = <Path>[
      // Top-left
      Path()
        ..moveTo(r, len)
        ..lineTo(r, r)
        ..arcToPoint(Offset(r + r, r), radius: Radius.circular(r), clockwise: true)
        ..lineTo(len, r),
      // Top-right
      Path()
        ..moveTo(w - len, r)
        ..lineTo(w - r, r)
        ..arcToPoint(Offset(w - r, r + r), radius: Radius.circular(r), clockwise: true)
        ..lineTo(w - r, len),
      // Bottom-left
      Path()
        ..moveTo(len, h - r)
        ..lineTo(r, h - r)
        ..arcToPoint(Offset(r, h - r - r), radius: Radius.circular(r), clockwise: false)
        ..lineTo(r, h - len),
      // Bottom-right
      Path()
        ..moveTo(w - r, h - len)
        ..lineTo(w - r, h - r)
        ..arcToPoint(Offset(w - r - r, h - r), radius: Radius.circular(r), clockwise: false)
        ..lineTo(w - len, h - r),
    ];

    for (final c in corners) {
      canvas.drawPath(c, cornerPaint);
    }
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double gapWidth,
  }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ViewfinderBorderPainter oldDelegate) => false;
}
