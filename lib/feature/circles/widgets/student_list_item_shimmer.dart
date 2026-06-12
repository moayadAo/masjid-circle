import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

/// Single item placeholder skeleton matching StudentListItemWidget
class StudentListItemShimmer extends StatelessWidget {
  const StudentListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors
            .transparent, // Keeps layout bounds transparent to avoid huge gray blocks
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          // Avatar Skeleton
          _circle(48),
          const SizedBox(width: AppSpacing.md),

          // Name + Code Skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 120, height: 16), // Student Name placeholder
                const SizedBox(height: AppSpacing.xs),
                _box(width: 60, height: 12), // Public Code placeholder
              ],
            ),
          ),

          // Status Badge Skeleton
          _box(width: 65, height: 24, radius: AppRadius.md),
          const SizedBox(width: AppSpacing.sm),

          // Chevron Skeleton
          _circle(20),
        ],
      ),
    );
  }

  // Primitive skeletal shapes helpers
  static Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  static Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// The List implementation wrapping the item skeletons inside the Shimmer gradient mask
class StudentListShimmer extends StatelessWidget {
  const StudentListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerLow,
      highlightColor: AppColor.surfaceContainerHighest,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 8, // Renders 8 item placeholders while fetching data
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, __) => const StudentListItemShimmer(),
      ),
    );
  }
}
