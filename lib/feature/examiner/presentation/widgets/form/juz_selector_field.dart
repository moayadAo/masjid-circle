import 'package:masjid/core/constant/export_theme_files.dart';

class JuzSelectorField extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const JuzSelectorField({
    super.key,
    required this.value,
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
              Icons.menu_book_rounded,
              size: 18.sp,
              color: AppColor.onSurfaceVariant,
            ),
            6.sbW,
            Text(
              'الجزء المختبر',
              style: AppTextStyle.labelLg(
                context,
                AppColor.onSurfaceVariant,
                14,
              ),
            ),
          ],
        ),
        8.sbH,
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(30, (i) {
              final juz = i + 1;
              final selected = value == juz;
              return ChoiceChip(
                label: Text('الجزء $juz'),
                selected: selected,
                onSelected: (_) => onChanged(selected ? null : juz),
                selectedColor: AppColor.secondaryContainer,
                labelStyle: AppTextStyle.labelLg(
                  context,
                  selected
                      ? AppColor.onSecondaryContainer
                      : AppColor.onSurfaceVariant,
                  13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
