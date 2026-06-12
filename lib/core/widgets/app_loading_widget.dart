import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';

/// Stylish loading indicator widget.
/// Usage: AppLoadingWidget(isLoading: true, message: 'Loading...')
class AppLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final double size;

  const AppLoadingWidget({
    Key? key,
    this.isLoading = true,
    this.message,
    this.size = 96.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        // Semi-transparent dark overlay with blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),
        ),
        // Centered card with animated rings and text
        Center(
          child: _LoadingCard(message: message, size: size),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatefulWidget {
  final String? message;
  final double size;

  const _LoadingCard({Key? key, this.message, required this.size})
    : super(key: key);

  @override
  State<_LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<_LoadingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: BoxConstraints(
          minWidth: widget.size,
          minHeight: widget.size * 0.6,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size * 0.6,
              child: Center(
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _ctrl.value * 6.28318,
                      child: child,
                    );
                  },
                  child: _Rings(size: widget.size * 0.45),
                ),
              ),
            ),
            if ((widget.message ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.message!,
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: theme.primaryColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Rings extends StatelessWidget {
  final double size;

  const _Rings({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              color: Colors.blueAccent.withOpacity(0.9),
              stroke: size * 0.12,
              gap: 0.3,
            ),
          ),
          // Inner ring with opposite gap
          Transform.scale(
            scale: 0.66,
            child: CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(
                color: Colors.greenAccent.withOpacity(0.9),
                stroke: size * 0.12,
                gap: 0.55,
              ),
            ),
          ),
          // Center dot
          Container(
            width: size * 0.18,
            height: size * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double stroke;
  final double gap; // fraction of the circle that is empty

  _RingPainter({required this.color, required this.stroke, this.gap = 0.35});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 6.28318,
        colors: [color.withOpacity(0.0), color, color.withOpacity(0.0)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    final start = 6.28318 * gap * 0.5;
    final sweep = 6.28318 * (1 - gap);
    canvas.drawArc(
      Rect.fromLTWH(
        stroke / 2,
        stroke / 2,
        size.width - stroke,
        size.height - stroke,
      ),
      start,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
