import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_state.dart';

class AddSessionBottomSheet extends StatefulWidget {
  final int circleId;

  const AddSessionBottomSheet({super.key, required this.circleId});

  @override
  State<AddSessionBottomSheet> createState() => _AddSessionBottomSheetState();
}

class _AddSessionBottomSheetState extends State<AddSessionBottomSheet> {
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColor.primaryContainer,
            onPrimary: AppColor.onPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    context.read<AttendanceSessionsCubit>().openSession(
      circleId: widget.circleId,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: .rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xxl),
            topRight: Radius.circular(AppRadius.xxl),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppColor.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'إضافة جلسة حضور جديدة',
                    style: AppTextStyle.headlineMd(
                      context,
                    ).copyWith(color: AppColor.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'يرجى تحديد التاريخ وإضافة أي ملاحظات للجلسة',
                    style: AppTextStyle.bodyMd(
                      context,
                    ).copyWith(color: AppColor.outline),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Date picker ─────────────────────────────
                  Text(
                    'التاريخ *',
                    style: AppTextStyle.labelLg(
                      context,
                      AppColor.outline,
                      null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F3EF),
                        border: Border.all(color: AppColor.border),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy/MM/dd').format(_selectedDate),
                            style: AppTextStyle.bodyMd(
                              context,
                            ).copyWith(color: AppColor.onSurface),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColor.outline,
                            size: AppIconSize.sm,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Notes ────────────────────────────────────
                  Text(
                    'ملاحظات (اختياري)',
                    style: AppTextStyle.labelLg(
                      context,
                      AppColor.outline,
                      null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    style: AppTextStyle.bodyMd(context),
                    decoration: InputDecoration(
                      hintText: 'أدخل أي ملاحظات خاصة بالجلسة...',
                      hintStyle: AppTextStyle.bodyMd(
                        context,
                      ).copyWith(color: AppColor.outline),
                      filled: true,
                      fillColor: const Color(0xFFF7F3EF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: const BorderSide(color: AppColor.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: const BorderSide(color: AppColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: const BorderSide(
                          color: AppColor.primaryContainer,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Submit button ────────────────────────────
                  BlocConsumer<
                    AttendanceSessionsCubit,
                    AttendanceSessionsState
                  >(
                    listener: (context, state) {
                      if (state is OpenSessionSuccessState) {
                        Navigator.pop(context);
                      }
                      if (state is OpenSessionFailureState) {
                        AppToast.error(context, state.errMessage);
                      }
                    },
                    buildWhen: (_, state) =>
                        state is OpenSessionLoadingState ||
                        state is OpenSessionSuccessState ||
                        state is OpenSessionFailureState,
                    builder: (context, state) {
                      final isLoading = state is OpenSessionLoadingState;
                      return SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryContainer,
                            foregroundColor: AppColor.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColor.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add_circle_outline),
                          label: Text(
                            'إنشاء الجلسة',
                            style: AppTextStyle.headlineMd(
                              context,
                            ).copyWith(color: AppColor.onPrimary, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Cancel
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.outline,
                        null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
