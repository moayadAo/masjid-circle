import 'package:masjid/core/constant/export_theme_files.dart';

import '../../../data/models/examiner_student_model.dart';

class StudentHeaderCard extends StatelessWidget {
  final ExaminerStudentModel student;

  const StudentHeaderCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: AppColor.primary.withOpacity(0.05), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColor.primaryFixed,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              student.initials,
              style: AppTextStyle.labelLg(context, AppColor.primary, 20),
            ),
          ),
          12.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.fullName, style: AppTextStyle.headlineMd(context)),
                6.sbH,
                Row(
                  children: [
                    if (student.circle != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryContainer,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          student.circle!.name,
                          style: AppTextStyle.labelLg(
                            context,
                            AppColor.onSecondaryContainer,
                            12,
                          ),
                        ),
                      ),
                    8.sbW,
                    Text(
                      '#${student.publicCode}',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.outline,
                        12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
