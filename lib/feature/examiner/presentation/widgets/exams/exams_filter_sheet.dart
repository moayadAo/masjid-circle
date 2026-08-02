import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/design_app/app_toast/app_toast.dart';

import '../../cubit/all_juz_exams_cubit.dart';

class ExamsFilterResult {
  final int? juzNumber;
  final String? rating;
  final String? dateFrom;
  final String? dateTo;
  final ExamsOrderBy orderBy;
  final String orderDirection;

  const ExamsFilterResult({
    this.juzNumber,
    this.rating,
    this.dateFrom,
    this.dateTo,
    required this.orderBy,
    required this.orderDirection,
  });
}

/// Shows the filter sheet and returns the chosen filters, or null if
/// dismissed without applying.
Future<ExamsFilterResult?> showExamsFilterSheet(
  BuildContext context, {
  int? currentJuz,
  String? currentRating,
  DateTime? currentFrom,
  DateTime? currentTo,
  ExamsOrderBy currentOrderBy = ExamsOrderBy.passedAt,
  String currentOrderDirection = 'desc',
}) {
  return showModalBottomSheet<ExamsFilterResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (ctx) => _ExamsFilterSheetContent(
      currentJuz: currentJuz,
      currentRating: currentRating,
      currentFrom: currentFrom,
      currentTo: currentTo,
      currentOrderBy: currentOrderBy,
      currentOrderDirection: currentOrderDirection,
    ),
  );
}

class _ExamsFilterSheetContent extends StatefulWidget {
  final int? currentJuz;
  final String? currentRating;
  final DateTime? currentFrom;
  final DateTime? currentTo;
  final ExamsOrderBy currentOrderBy;
  final String currentOrderDirection;

  const _ExamsFilterSheetContent({
    required this.currentJuz,
    required this.currentRating,
    required this.currentFrom,
    required this.currentTo,
    required this.currentOrderBy,
    required this.currentOrderDirection,
  });

  @override
  State<_ExamsFilterSheetContent> createState() =>
      _ExamsFilterSheetContentState();
}

class _ExamsFilterSheetContentState extends State<_ExamsFilterSheetContent> {
  int? _juz;
  String? _rating;
  DateTime? _from;
  DateTime? _to;
  late ExamsOrderBy _orderBy;
  late String _orderDirection;

  static const _ratings = [
    ('excellent', 'ممتاز'),
    ('very_good', 'جيد جداً'),
    ('good', 'جيد'),
    ('failed', 'لم ينجح'),
  ];

  static const _sorts = [
    (ExamsOrderBy.passedAt, 'تاريخ الاختبار'),
    (ExamsOrderBy.createdAt, 'تاريخ الإضافة'),
    (ExamsOrderBy.juzNumber, 'رقم الجزء'),
  ];

  @override
  void initState() {
    super.initState();
    _juz = widget.currentJuz;
    _rating = widget.currentRating;
    _from = widget.currentFrom;
    _to = widget.currentTo;
    _orderBy = widget.currentOrderBy;
    _orderDirection = widget.currentOrderDirection;
  }

  DateTime _todayOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _normalize(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final today = _todayOnly();
    DateTime initialDate = isFrom ? (_from ?? today) : (_to ?? today);
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = today;

    if (isFrom) {
      if (_to != null) {
        final toDate = _normalize(_to!);
        lastDate = toDate.isBefore(lastDate) ? toDate : lastDate;
        initialDate = _normalize(initialDate);
        if (initialDate.isAfter(toDate)) {
          initialDate = toDate;
        }
      }
    } else {
      if (_from != null) {
        firstDate = _normalize(_from!);
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _normalize(initialDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;

    final normalizedPicked = _normalize(picked);
    if (isFrom) {
      if (_to != null && normalizedPicked.isAfter(_normalize(_to!))) {
        setState(() {
          _from = normalizedPicked;
          _to = normalizedPicked;
        });
      } else {
        setState(() => _from = normalizedPicked);
      }
      return;
    }

    if (_from != null && normalizedPicked.isBefore(_normalize(_from!))) {
      AppToast.warning(context, 'تاريخ "إلى" لا يمكن أن يكون قبل تاريخ "من"');
      return;
    }

    setState(() => _to = normalizedPicked);
  }

  String? _fmt(DateTime? d) => d == null
      ? null
      : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        20.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColor.outlineVariant,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            16.sbH,
            Text('تصفية النتائج', style: AppTextStyle.headlineMd(context)),
            20.sbH,

            Text(
              'التقييم',
              style: AppTextStyle.labelLg(context, AppColor.primary, 14),
            ),
            10.sbH,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _ratings.map((r) {
                final selected = _rating == r.$1;
                return ChoiceChip(
                  label: Text(r.$2),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _rating = selected ? null : r.$1),
                  selectedColor: AppColor.secondaryContainer,
                  labelStyle: AppTextStyle.labelLg(
                    context,
                    selected
                        ? AppColor.onSecondaryContainer
                        : AppColor.onSurfaceVariant,
                    13,
                  ),
                );
              }).toList(),
            ),

            20.sbH,
            Text(
              'رقم الجزء',
              style: AppTextStyle.labelLg(context, AppColor.primary, 14),
            ),
            10.sbH,
            DropdownButtonFormField<int>(
              initialValue: _juz,
              isExpanded: true,
              hint: const Text('كل الأجزاء'),
              items: List.generate(
                30,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('الجزء ${i + 1}'),
                ),
              ),
              onChanged: (v) => setState(() => _juz = v),
            ),

            20.sbH,
            Text(
              'من تاريخ - إلى تاريخ',
              style: AppTextStyle.labelLg(context, AppColor.primary, 14),
            ),
            10.sbH,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isFrom: true),
                    child: Text(_fmt(_from) ?? 'من تاريخ'),
                  ),
                ),
                8.sbW,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isFrom: false),
                    child: Text(_fmt(_to) ?? 'إلى تاريخ'),
                  ),
                ),
              ],
            ),

            20.sbH,
            Text(
              'الترتيب حسب',
              style: AppTextStyle.labelLg(context, AppColor.primary, 14),
            ),
            10.sbH,
            DropdownButtonFormField<ExamsOrderBy>(
              initialValue: _orderBy,
              isExpanded: true,
              items: _sorts
                  .map((s) => DropdownMenuItem(value: s.$1, child: Text(s.$2)))
                  .toList(),
              onChanged: (v) => setState(() => _orderBy = v ?? _orderBy),
            ),
            8.sbH,
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('الأحدث أولاً'),
                    value: 'desc',
                    groupValue: _orderDirection,
                    onChanged: (v) => setState(() => _orderDirection = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('الأقدم أولاً'),
                    value: 'asc',
                    groupValue: _orderDirection,
                    onChanged: (v) => setState(() => _orderDirection = v!),
                  ),
                ),
              ],
            ),

            24.sbH,
            SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_from != null && _to != null && _from!.isAfter(_to!)) {
                    AppToast.warning(
                      context,
                      'تاريخ "إلى" لا يمكن أن يكون قبل تاريخ "من"',
                    );
                    return;
                  }

                  Navigator.pop(
                    context,
                    ExamsFilterResult(
                      juzNumber: _juz,
                      rating: _rating,
                      dateFrom: _fmt(_from),
                      dateTo: _fmt(_to),
                      orderBy: _orderBy,
                      orderDirection: _orderDirection,
                    ),
                  );
                },
                child: const Text('تطبيق'),
              ),
            ),
            8.sbH,
            TextButton(
              onPressed: () => setState(() {
                _juz = null;
                _rating = null;
                _from = null;
                _to = null;
                _orderBy = ExamsOrderBy.passedAt;
                _orderDirection = 'desc';
              }),
              child: const Text('إعادة تعيين'),
            ),
          ],
        ),
      ),
    );
  }
}
