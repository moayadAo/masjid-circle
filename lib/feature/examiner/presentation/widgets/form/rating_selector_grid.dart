import 'package:masjid/core/constant/export_theme_files.dart';

import '../../../data/models/juz_exam_model.dart';

class RatingSelectorGrid extends StatelessWidget {
  final JuzExamRating? selected;
  final ValueChanged<JuzExamRating> onSelected;

  const RatingSelectorGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _options = [
    (
      JuzExamRating.excellent,
      Icons.workspace_premium_rounded,
      AppColor.tertiary,
    ),
    (
      JuzExamRating.veryGood,
      Icons.sentiment_very_satisfied_rounded,
      AppColor.secondary,
    ),
    (
      JuzExamRating.good,
      Icons.sentiment_satisfied_rounded,
      AppColor.onSurfaceVariant,
    ),
    (
      JuzExamRating.failed,
      Icons.sentiment_very_dissatisfied_rounded,
      AppColor.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.verified_rounded,
              size: 18.sp,
              color: AppColor.onSurfaceVariant,
            ),
            6.sbW,
            Text(
              'النتيجة والتقييم',
              style: AppTextStyle.labelLg(
                context,
                AppColor.onSurfaceVariant,
                14,
              ),
            ),
          ],
        ),
        10.sbH,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1.7,
          children: _options.map((o) {
            final isSelected = selected == o.$1;
            final isFailed = o.$1 == JuzExamRating.failed;
            return InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => onSelected(o.$1),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isFailed
                            ? AppColor.errorContainer
                            : AppColor.primaryFixed.withOpacity(0.4))
                      : AppColor.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? (isFailed ? AppColor.error : AppColor.primary)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(o.$2, size: 26.sp, color: o.$3),
                    4.sbH,
                    Text(
                      o.$1.arabicLabel,
                      style: AppTextStyle.labelLg(
                        context,
                        isSelected
                            ? (isFailed ? AppColor.error : AppColor.primary)
                            : AppColor.onSurfaceVariant,
                        13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
