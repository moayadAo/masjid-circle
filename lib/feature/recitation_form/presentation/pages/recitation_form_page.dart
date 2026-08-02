// recitation_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/app_toast/app_toast.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/di/service_locator.dart';
import '../../../recitation_form/data/remote/recitation_form_service.dart';
import '../../data/models/recitation_model.dart';
import '../cubit/recitation_form_cubit.dart';
import '../cubit/recitation_form_state.dart';
import '../widgets/notes_field.dart';
import '../widgets/pages_recitation_tab.dart';
import '../widgets/rating_selector.dart';
import '../widgets/recitation_confirm_button.dart';
import '../widgets/recitation_form_header.dart';
import '../widgets/recitation_type_tab_bar.dart';
import '../widgets/surah_picker_bottom_sheet.dart';
import '../widgets/surah_recitation_tab.dart';

Future<RecitationModel?> showRecitationFormSheet(
  BuildContext context, {
  required int studentId,
  required String studentName,
  required int circleId,
  required int cycleId,
}) {
  return showModalBottomSheet<RecitationModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RecitationFormPage(
      studentId: studentId,
      studentName: studentName,
      circleId: circleId,
      cycleId: cycleId,
    ),
  );
}

class RecitationFormPage extends StatelessWidget {
  final int studentId;
  final String studentName;
  final int circleId;
  final int cycleId;

  const RecitationFormPage({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.circleId,
    required this.cycleId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecitationFormCubit(
        recitationService: getIt<RecitationFormService>(),
      ),
      child: _RecitationFormView(
        studentId: studentId,
        studentName: studentName,
        circleId: circleId,
        cycleId: cycleId,
      ),
    );
  }
}

class _RecitationFormView extends StatefulWidget {
  final int studentId;
  final String studentName;
  final int circleId;
  final int cycleId;

  const _RecitationFormView({
    required this.studentId,
    required this.studentName,
    required this.circleId,
    required this.cycleId,
  });

  @override
  State<_RecitationFormView> createState() => _RecitationFormViewState();
}

class _RecitationFormViewState extends State<_RecitationFormView> {
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime _todayOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String get _selectedIsoDate {
    final date = _selectedDate;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate(BuildContext context) async {
    final today = _todayOnly();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
    );

    if (picked == null) return;
    if (picked.isAfter(today)) {
      AppToast.warning(context, 'لا يمكن اختيار تاريخ لاحق ليومنا');
      return;
    }

    setState(() => _selectedDate = picked);
  }

  Future<void> _openSurahPicker(BuildContext context) async {
    final cubit = context.read<RecitationFormCubit>();
    final surah = await showSurahPickerBottomSheet(
      context,
      currentSurah: cubit.state.selectedSurah,
    );
    if (surah != null) {
      cubit.selectSurah(surah);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardPadding),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      // Wrap everything inside a Material widget to satisfy InkWells and inputs
      child: Material(
        color:
            Colors.transparent, // Keeps our bottom sheet's original appearance
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BlocConsumer<RecitationFormCubit, RecitationFormState>(
              listener: (context, state) {
                if (state.submissionStatus ==
                    RecitationSubmissionStatus.failure) {
                  AppToast.error(context, state.errorMessage ?? '');
                } else if (state.submissionStatus ==
                    RecitationSubmissionStatus.success) {
                  AppToast.success(context, 'تم تسجيل التسميع بنجاح');
                  Navigator.pop(context, state.result);
                }
              },
              builder: (context, state) {
                final cubit = context.read<RecitationFormCubit>();
                final isLoading =
                    state.submissionStatus ==
                    RecitationSubmissionStatus.loading;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.md.w,
                          AppSpacing.md.h,
                          AppSpacing.md.w,
                          AppSpacing.lg.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RecitationFormHeader(
                              studentName: widget.studentName,
                              onClose: () => Navigator.pop(context),
                            ),
                            AppSpacing.lg.sbH,
                            RecitationTypeTabBar(
                              selectedTab: state.selectedTab,
                              onChanged: cubit.changeTab,
                            ),
                            AppSpacing.lg.sbH,
                            if (state.selectedTab == RecitationFormTab.pages)
                              PagesRecitationTab(
                                fromPage: state.fromPage,
                                toPage: state.toPage,
                                onFromIncrement: cubit.incrementFromPage,
                                onFromDecrement: cubit.decrementFromPage,
                                onToIncrement: cubit.incrementToPage,
                                onToDecrement: cubit.decrementToPage,
                                onFromManualChanged: cubit.updateFromPage,
                                onToManualChanged: cubit.updateToPage,
                              )
                            else
                              SurahRecitationTab(
                                selectedSurah: state.selectedSurah,
                                onTap: () => _openSurahPicker(context),
                              ),
                            AppSpacing.lg.sbH,
                            InkWell(
                              onTap: () => _pickDate(context),
                              borderRadius: BorderRadius.circular(
                                AppRadius.md.r,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md.w,
                                  vertical: AppSpacing.md.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md.r,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: AppColor.onSurfaceVariant,
                                    ),
                                    AppSpacing.sm.sbW,
                                    Expanded(
                                      child: Text(
                                        'تاريخ التسميع: ${_selectedIsoDate}',
                                        style: AppTextStyle.bodyLg(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSpacing.lg.sbH,
                            RatingSelector(
                              selected: state.rating,
                              onChanged: cubit.selectRating,
                            ),
                            AppSpacing.lg.sbH,
                            NotesField(controller: _notesController),
                            AppSpacing.lg.sbH,
                            RecitationConfirmButton(
                              isLoading: isLoading,
                              onPressed: state.canSubmit
                                  ? () => cubit.submit(
                                      cycleId: widget.cycleId,
                                      circleId: widget.circleId,
                                      studentId: widget.studentId,
                                      recitedAt: _selectedIsoDate,
                                      notes: _notesController.text,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
