import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceSessionPageShimmer extends StatelessWidget {
  const AttendanceSessionPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerLow,
      highlightColor: AppColor.surfaceContainerHighest,
      child: Column(
        children: [
          // ── Header Placeholder ──────────────────────────────
          _buildHeaderPlaceholder(),

          // ── Column Labels Placeholder ───────────────────────
          _buildLabelsPlaceholder(),

          // ── Students List Placeholder ───────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: 6, // Showing 6 mock rows while loading
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, __) => _buildRecordRowPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  /// Replicates the AttendanceHeaderWidget structure cleanly
  Widget _buildHeaderPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.transparent, // Keeping layout bounds transparent
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 140, height: 16), // Teacher Name block
              const SizedBox(height: AppSpacing.sm),
              _box(width: 90, height: 18), // Date block
            ],
          ),
          // Total Counter Right Badge
          _box(width: 80, height: 50, radius: AppRadius.md),
        ],
      ),
    );
  }

  /// Replicates the _ColumnLabelsRow widget structure
  Widget _buildLabelsPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors
            .white, // This row is entirely one background container style in original UI
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      height: 45, // Hardcoded fixed matching row height
    );
  }

  /// Replicates the AttendanceRecordRowWidget structure
  Widget _buildRecordRowPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          // Avatar + Name structure skeleton
          Expanded(
            flex: 4,
            child: Row(
              children: [
                _circle(36), // Student avatar circle
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _box(
                    width: double.infinity,
                    height: 16,
                  ), // Student Name box
                ),
              ],
            ),
          ),

          // 4 Interactive Status Status Circle Actions Skeletons
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (_) => _circle(40)),
            ),
          ),
        ],
      ),
    );
  }

  // Helper primitives constructors
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
