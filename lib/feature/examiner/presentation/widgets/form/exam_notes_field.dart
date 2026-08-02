import 'package:masjid/core/constant/export_theme_files.dart';

class ExamNotesField extends StatelessWidget {
  final bool required;
  final ValueChanged<String> onChanged;

  const ExamNotesField({
    super.key,
    required this.required,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_rounded,
              size: 18.sp,
              color: AppColor.onSurfaceVariant,
            ),
            6.sbW,
            Text(
              'ملاحظات التقييم',
              style: AppTextStyle.labelLg(
                context,
                AppColor.onSurfaceVariant,
                14,
              ),
            ),
            const Spacer(),
            if (required)
              Text(
                'مطلوبة',
                style: AppTextStyle.labelLg(context, AppColor.error, 12),
              ),
          ],
        ),
        8.sbH,
        TextField(
          onChanged: onChanged,
          maxLines: 4,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.surfaceContainerLow,
            hintText: 'اكتب أي ملاحظات تتعلق بأداء الطالب في هذا الجزء...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: required
                  ? BorderSide(
                      color: AppColor.error.withOpacity(0.4),
                      width: 1.5,
                    )
                  : BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
