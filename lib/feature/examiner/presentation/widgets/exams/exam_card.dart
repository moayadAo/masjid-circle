import 'package:masjid/core/constant/export_theme_files.dart';

import '../../../data/models/juz_exam_model.dart';
import 'rating_badge.dart';

class ExamCard extends StatelessWidget {
  final JuzExamModel exam;

  /// Whether to show the student name row (used in the mosque-wide list;
  /// hidden on the single-student history page since it's redundant there).
  final bool showStudentName;

  const ExamCard({super.key, required this.exam, this.showStudentName = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showStudentName && exam.student != null)
                      Text(
                        exam.student!.fullName,
                        style: AppTextStyle.headlineMd(context),
                      ),
                    Text(
                      'اختبار الجزء ${exam.juzNumber}',
                      style: AppTextStyle.bodyMd(context).copyWith(
                        color: showStudentName
                            ? AppColor.onSurfaceVariant
                            : AppColor.onSurface,
                      ),
                    ),
                    4.sbH,
                    Text(
                      'تم الاختبار في ${exam.passedAt}',
                      // exam.passedAt,
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onSurfaceVariant,
                        12,
                      ),
                    ),
                  ],
                ),
              ),
              RatingBadge(rating: exam.ratingEnum),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              children: [
                if (exam.teacher != null) ...[
                  Icon(
                    Icons.person_rounded,
                    size: 16.sp,
                    color: AppColor.primary,
                  ),
                  4.sbW,
                  Expanded(
                    child: Text(
                      exam.teacher!.name,
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onSurfaceVariant,
                        13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (exam.pointsAwarded != null && exam.pointsAwarded! > 0)
                  Row(
                    children: [
                      Icon(
                        Icons.military_tech_rounded,
                        size: 16.sp,
                        color: AppColor.tertiary,
                      ),
                      4.sbW,
                      Text(
                        '+${exam.pointsAwarded} نقطة',
                        style: AppTextStyle.labelLg(
                          context,
                          AppColor.tertiary,
                          13,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          //! circle name if not null
          if (exam.circle != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.group_rounded,
                    size: 16.sp,
                    color: AppColor.primary,
                  ),
                  4.sbW,
                  Expanded(
                    child: Text(
                      'حلقة: ${exam.circle!.name}',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onSurfaceVariant,
                        13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (exam.notes != null && exam.notes!.trim().isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.all(10.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                exam.notes!,
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}
