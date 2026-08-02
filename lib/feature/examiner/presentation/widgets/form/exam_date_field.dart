import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/design_app/app_toast/app_toast.dart';

class ExamDateField extends StatelessWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const ExamDateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String get _formatted =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  DateTime _todayOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pick(BuildContext context) async {
    final today = _todayOnly();
    final initialDate = value.isAfter(today) ? today : value;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: today,
    );

    if (picked == null) return;
    if (picked.isAfter(today)) {
      AppToast.warning(context, 'لا يمكن اختيار تاريخ لاحق ليومنا');
      return;
    }
    onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18.sp,
              color: AppColor.onSurfaceVariant,
            ),
            6.sbW,
            Text(
              'تاريخ الاختبار',
              style: AppTextStyle.labelLg(
                context,
                AppColor.onSurfaceVariant,
                14,
              ),
            ),
          ],
        ),
        8.sbH,
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () => _pick(context),
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColor.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(_formatted, style: AppTextStyle.bodyLg(context)),
                ),
                Icon(Icons.edit_calendar_outlined, color: AppColor.outline),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
