// export_report_dialog.dart
//
// Dialog shown when the teacher taps "تصدير تقرير".
// Lets them pick a date (defaults to today) then confirms export.

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class ExportReportDialog extends StatefulWidget {
  /// Called with the selected date string (YYYY-MM-DD) when confirmed.
  final void Function(String date) onExport;

  const ExportReportDialog({super.key, required this.onExport});

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool get _isToday {
    final d = _selectedDate;
    final t = _today;
    return d.year == t.year && d.month == t.month && d.day == t.day;
  }

  String get _formattedDate {
    final d = _selectedDate;
    return '${d.year.toString().padLeft(4, '0')}'
        '-${d.month.toString().padLeft(2, '0')}'
        '-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: _today,
      locale: const Locale('ar'),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: AppColor.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ─────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColor.primary,
                      size: AppIconSize.sm,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'تصدير تقرير التسميع',
                    style: AppTextStyle.headlineMd(context).copyWith(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Subtitle ──────────────────────────────────
              Text(
                'اختر تاريخ اليوم الذي تريد توليد التقرير له، أو اتركه كما هو لتقرير اليوم.',
                style: AppTextStyle.bodyMd(context).copyWith(
                  color: AppColor.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Date picker field ─────────────────────────
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColor.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: AppIconSize.sm,
                        color: AppColor.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formattedDate,
                              style: AppTextStyle.bodyMd(context).copyWith(
                                color: AppColor.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_isToday)
                              Text(
                                'اليوم (افتراضي)',
                                style: AppTextStyle.labelLg(
                                  context,
                                  AppColor.secondary,
                                  11,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        'تغيير',
                        style: AppTextStyle.labelLg(
                          context,
                          AppColor.primaryContainer,
                          12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Action buttons ────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onExport(_formattedDate);
                      },
                      icon: const Icon(Icons.ios_share_rounded, size: 18),
                      label: const Text('تصدير ومشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryContainer,
                        foregroundColor: AppColor.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
