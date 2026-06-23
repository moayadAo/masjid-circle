// student_profile_shimmer.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:shimmer/shimmer.dart';

class StudentProfileShimmer extends StatelessWidget {
  const StudentProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerHigh,
      highlightColor: AppColor.surfaceContainerLowest,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile header card ───────────────────────
            _ShimmerBox(height: 160, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.md),

            // ── Three info cards ──────────────────────────
            _ShimmerBox(height: 140, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(height: 140, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(height: 140, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.md),

            // ── Recitations section header ────────────────
            _ShimmerBox(height: 28, width: 140, borderRadius: AppRadius.lg),
            const SizedBox(height: AppSpacing.md),

            // ── Recitation cards ──────────────────────────
            _ShimmerBox(height: 110, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(height: 110, borderRadius: AppRadius.xl),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(height: 110, borderRadius: AppRadius.xl),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _ShimmerBox({
    required this.height,
    this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
