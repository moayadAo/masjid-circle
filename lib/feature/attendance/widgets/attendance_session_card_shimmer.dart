import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceSessionCardShimmer extends StatelessWidget {
  const AttendanceSessionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerLow,
      highlightColor: AppColor.surfaceContainerHighest,
      child: Container(
        // FIXED: Changed background to transparent so it doesn't block out the inner widgets
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: const Border(
            right: BorderSide(color: Colors.white, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _box(width: 45, height: 18),
                    const SizedBox(width: AppSpacing.sm),
                    _box(width: 90, height: 20),
                  ],
                ),

                /// Status badge
                _box(width: 80, height: 32, radius: AppRadius.md),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            /// Meta row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _circle(18),
                      const SizedBox(width: AppSpacing.xs),
                      _box(width: 90, height: 14),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      _circle(18),
                      const SizedBox(width: AppSpacing.xs),
                      _box(width: 70, height: 14),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // FIXED: Using an actual solid container for the divider line
            // standard Divider widget might not catch the shimmer properly
            Container(height: 1, color: Colors.white),

            const SizedBox(height: AppSpacing.xs),

            /// Notes
            Row(
              children: [
                _circle(18),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: _box(width: double.infinity, height: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box({
    required double width,
    required double height,
    double radius = 8,
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

class AttendanceSessionListShimmer extends StatelessWidget {
  const AttendanceSessionListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const AttendanceSessionCardShimmer(),
    );
  }
}
