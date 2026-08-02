import 'package:masjid/core/constant/export_theme_files.dart';

import '../../../data/models/examiner_student_model.dart';

class StudentCard extends StatelessWidget {
  final ExaminerStudentModel student;
  final VoidCallback onTap;

  const StudentCard({super.key, required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = student.isActive;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
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
      child: Opacity(
        opacity: active ? 1 : 0.7,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(student: student),
            12.sbW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          student.fullName,
                          style: AppTextStyle.headlineMd(context).copyWith(
                            color: active
                                ? AppColor.primary
                                : AppColor.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusChip(active: active),
                    ],
                  ),
                  6.sbH,
                  if (student.circle != null)
                    _InfoLine(
                      icon: Icons.menu_book_rounded,
                      text: student.circle!.name,
                    ),
                  4.sbH,
                  _InfoLine(
                    icon: Icons.fingerprint_rounded,
                    text: student.publicCode,
                  ),
                  10.sbH,
                  SizedBox(
                    height: 40.h,
                    child: ElevatedButton.icon(
                      onPressed: active ? onTap : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: active
                            ? AppColor.primary
                            : AppColor.surfaceVariant,
                        foregroundColor: active
                            ? AppColor.onPrimary
                            : AppColor.onSurfaceVariant,
                      ),
                      icon: Icon(
                        active ? Icons.quiz_rounded : Icons.block_rounded,
                        size: 18.sp,
                      ),
                      label: Text(active ? 'إجراء اختبار' : 'غير متاح'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ExaminerStudentModel student;
  const _Avatar({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: AppColor.secondaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        student.initials,
        style: AppTextStyle.labelLg(context, AppColor.primary, 18),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool active;
  const _StatusChip({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: active ? AppColor.secondaryContainer : AppColor.surfaceVariant,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        active ? 'نشط' : 'غير نشط',
        style: AppTextStyle.labelLg(
          context,
          active ? AppColor.onSecondaryContainer : AppColor.onSurfaceVariant,
          12,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColor.onSurfaceVariant),
        4.sbW,
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.labelLg(context, AppColor.onSurfaceVariant, 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
