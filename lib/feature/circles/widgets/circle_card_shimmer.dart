import 'package:shimmer/shimmer.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleCardShimmer extends StatelessWidget {
  const CircleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerLow,
      highlightColor: AppColor.surfaceContainerHighest,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(AppRadius.xl),
          ),
          border: Border.all(color: AppColor.surfaceVariant),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    bottomLeft: Radius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(height: 20, width: 180),
                            const SizedBox(height: 8),
                            _box(height: 14, width: 100),
                          ],
                        ),
                      ),
                      _box(height: 32, width: 70, radius: AppRadius.md),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  /// Stat card
                  Row(
                    children: [
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _circle(14),
                                  const SizedBox(width: 6),
                                  _box(height: 12, width: 50),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _box(height: 18, width: 90),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  /// Button
                  _box(
                    height: 44,
                    width: double.infinity,
                    radius: AppRadius.lg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box({
    required double height,
    required double width,
    double radius = 8,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  static Widget _circle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class CircleListShimmer extends StatelessWidget {
  const CircleListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const CircleCardShimmer(),
    );
  }
}
