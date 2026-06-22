// // recitations_filter_sheet.dart

// import 'package:flutter/material.dart';
// import 'package:masjid/core/constant/export_theme_files.dart';

// class RecitationsFilterSheet extends StatefulWidget {
//   final String? initialFromDate;
//   final String? initialToDate;
//   final void Function(String? fromDate, String? toDate) onApply;
//   final VoidCallback onClear;

//   const RecitationsFilterSheet({
//     super.key,
//     required this.initialFromDate,
//     required this.initialToDate,
//     required this.onApply,
//     required this.onClear,
//   });

//   @override
//   State<RecitationsFilterSheet> createState() => _RecitationsFilterSheetState();
// }

// class _RecitationsFilterSheetState extends State<RecitationsFilterSheet> {
//   DateTime? _fromDate;
//   DateTime? _toDate;

//   @override
//   void initState() {
//     super.initState();
//     _fromDate = _tryParse(widget.initialFromDate);
//     _toDate = _tryParse(widget.initialToDate);
//   }

//   DateTime? _tryParse(String? value) {
//     if (value == null || value.isEmpty) return null;
//     return DateTime.tryParse(value);
//   }

//   String _format(DateTime date) {
//     final y = date.year.toString().padLeft(4, '0');
//     final m = date.month.toString().padLeft(2, '0');
//     final d = date.day.toString().padLeft(2, '0');
//     return '$y-$m-$d';
//   }

//   Future<void> _pickDate({required bool isFrom}) async {
//     final initial = isFrom
//         ? (_fromDate ?? DateTime.now())
//         : (_toDate ?? DateTime.now());
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       locale: const Locale('ar'),
//     );
//     if (picked == null) return;
//     setState(() {
//       if (isFrom) {
//         _fromDate = picked;
//       } else {
//         _toDate = picked;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Container(
//         padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
//         decoration: BoxDecoration(
//           color: AppColor.surfaceContainerLowest,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('تصفية حسب التاريخ', style: AppTextStyle.headlineMd(context)),
//             SizedBox(height: 16.h),
//             _DateField(
//               label: 'من تاريخ',
//               value: _fromDate != null ? _format(_fromDate!) : null,
//               onTap: () => _pickDate(isFrom: true),
//             ),
//             SizedBox(height: 12.h),
//             _DateField(
//               label: 'إلى تاريخ',
//               value: _toDate != null ? _format(_toDate!) : null,
//               onTap: () => _pickDate(isFrom: false),
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       widget.onClear();
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('مسح'),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       widget.onApply(
//                         _fromDate != null ? _format(_fromDate!) : null,
//                         _toDate != null ? _format(_toDate!) : null,
//                       );
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('تصفية'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DateField extends StatelessWidget {
//   final String label;
//   final String? value;
//   final VoidCallback onTap;

//   const _DateField({
//     required this.label,
//     required this.value,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//         decoration: BoxDecoration(
//           color: AppColor.surfaceContainerLow,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: AppColor.outlineVariant),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.calendar_today_rounded,
//               size: 18.sp,
//               color: AppColor.onSurfaceVariant,
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Text(
//                 value ?? label,
//                 style: AppTextStyle.bodyMd(context).copyWith(
//                   color: value != null
//                       ? AppColor.onSurface
//                       : AppColor.onSurfaceVariant,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// recitations_filter_sheet.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class RecitationsFilterSheet extends StatefulWidget {
  final String? initialFromDate;
  final String? initialToDate;
  final void Function(String? fromDate, String? toDate) onApply;
  final VoidCallback onClear;

  const RecitationsFilterSheet({
    super.key,
    required this.initialFromDate,
    required this.initialToDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<RecitationsFilterSheet> createState() => _RecitationsFilterSheetState();
}

class _RecitationsFilterSheetState extends State<RecitationsFilterSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _fromDate = _tryParse(widget.initialFromDate);
    _toDate = _tryParse(widget.initialToDate);
  }

  DateTime? _tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  String _format(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? _today,
      firstDate: DateTime(2020),
      // From-date cannot be later than today, and also cannot be later
      // than the currently selected to-date (if any).
      lastDate: _toDate != null && _toDate!.isBefore(_today)
          ? _toDate!
          : _today,
      locale: const Locale('ar'),
    );
    if (picked == null) return;

    setState(() {
      _fromDate = picked;
      // If existing to-date is now before the new from-date, clear it
      // so the range stays valid.
      if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
        _toDate = null;
      }
    });
  }

  Future<void> _pickToDate() async {
    if (_fromDate == null) {
      AppToast.warning(context, 'يرجى اختيار "من تاريخ" أولاً');
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate != null && !_toDate!.isBefore(_fromDate!)
          ? _toDate!
          : _fromDate!,
      // To-date cannot be before from-date.
      firstDate: _fromDate!,
      // To-date cannot be after today.
      lastDate: _today,
      locale: const Locale('ar'),
    );
    if (picked == null) return;

    setState(() => _toDate = picked);
  }

  bool get _canApply {
    if (_fromDate == null && _toDate == null) return true;
    if (_fromDate != null && _toDate != null) {
      return !_toDate!.isBefore(_fromDate!);
    }
    return true;
  }

  void _handleApply() {
    if (!_canApply) {
      AppToast.error(
        context,
        '"إلى تاريخ" يجب أن يكون بعد أو يساوي "من تاريخ"',
      );
      return;
    }
    widget.onApply(
      _fromDate != null ? _format(_fromDate!) : null,
      _toDate != null ? _format(_toDate!) : null,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColor.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تصفية حسب التاريخ', style: AppTextStyle.headlineMd(context)),
            SizedBox(height: 16.h),
            _DateField(
              label: 'من تاريخ',
              value: _fromDate != null ? _format(_fromDate!) : null,
              onTap: _pickFromDate,
            ),
            SizedBox(height: 12.h),
            _DateField(
              label: 'إلى تاريخ',
              value: _toDate != null ? _format(_toDate!) : null,
              onTap: _pickToDate,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColor.outline, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      widget.onClear();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'مسح',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.primary,
                        14,
                      ).copyWith(color: AppColor.primary),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _handleApply,
                    child: Text(
                      'تصفية',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onPrimary,
                        14,
                      ).copyWith(color: AppColor.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18.sp,
              color: AppColor.onSurfaceVariant,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                value ?? label,
                style: AppTextStyle.bodyMd(context).copyWith(
                  color: value != null
                      ? AppColor.onSurface
                      : AppColor.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
