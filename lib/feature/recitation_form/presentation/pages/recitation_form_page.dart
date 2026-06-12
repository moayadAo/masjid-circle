// recitation_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

/// Opens the recitation form as a modal bottom sheet.
///
/// Returns the created [RecitationModel] on success, or null if the
/// sheet was dismissed without submitting.
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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _todayIsoDate {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md.w,
          AppSpacing.md.h,
          AppSpacing.md.w,
          AppSpacing.lg.h,
        ),
        decoration: BoxDecoration(
          color: AppColor.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
        ),
        child: SafeArea(
          top: false,
          child: BlocConsumer<RecitationFormCubit, RecitationFormState>(
            listener: (context, state) {
              if (state.submissionStatus == RecitationSubmissionStatus.failure) {
                AppToast.error(context, state.errorMessage ?? '');
              } else if (state.submissionStatus == RecitationSubmissionStatus.success) {
                AppToast.success(context, 'تم تسجيل التسميع بنجاح');
                Navigator.pop(context, state.result);
              }
            },
            builder: (context, state) {
              final cubit = context.read<RecitationFormCubit>();
              final isLoading =
                  state.submissionStatus == RecitationSubmissionStatus.loading;

              return SingleChildScrollView(
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
                      )
                    else
                      SurahRecitationTab(
                        selectedSurah: state.selectedSurah,
                        onTap: () => _openSurahPicker(context),
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
                                recitedAt: _todayIsoDate,
                                notes: _notesController.text,
                              )
                          : null,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
