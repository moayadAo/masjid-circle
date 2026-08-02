import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

import '../../data/models/examiner_student_model.dart';
import '../cubit/juz_exam_form_cubit.dart';
import '../cubit/juz_exam_form_state.dart';
import '../widgets/exams/student_header_card.dart';
import '../widgets/form/exam_date_field.dart';
import '../widgets/form/exam_notes_field.dart';
import '../widgets/form/juz_selector_field.dart';
import '../widgets/form/rating_selector_grid.dart';

class JuzExamFormPage extends StatefulWidget {
  final ExaminerStudentModel student;

  const JuzExamFormPage({super.key, required this.student});

  @override
  State<JuzExamFormPage> createState() => _JuzExamFormPageState();
}

class _JuzExamFormPageState extends State<JuzExamFormPage> {
  @override
  void initState() {
    super.initState();
    context.read<JuzExamFormCubit>().resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<JuzExamFormCubit>().resetForm();
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(title: const Text('إنشاء اختبار')),
        body: BlocConsumer<JuzExamFormCubit, JuzExamFormState>(
          listener: (context, state) {
            if (state is JuzExamFormValidationState) {
              AppToast.warning(context, state.errMessage);
            } else if (state is JuzExamFormFailureState) {
              AppToast.error(context, state.errMessage);
            } else if (state is JuzExamFormSuccessState) {
              context.read<JuzExamFormCubit>().resetForm();
              AppToast.success(context, 'تم حفظ الاختبار بنجاح');
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<JuzExamFormCubit>();
            final submitting = state is JuzExamFormSubmittingState;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StudentHeaderCard(student: widget.student),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        JuzSelectorField(
                          value: cubit.juzNumber,
                          onChanged: (v) {
                            if (v != null) cubit.selectJuz(v);
                          },
                        ),
                        20.sbH,
                        ExamDateField(
                          value: cubit.passedAt,
                          onChanged: cubit.selectDate,
                        ),
                        20.sbH,
                        RatingSelectorGrid(
                          selected: cubit.rating,
                          onSelected: cubit.selectRating,
                        ),
                        20.sbH,
                        ExamNotesField(
                          required: cubit.isNotesRequired,
                          onChanged: cubit.updateNotes,
                        ),
                        24.sbH,
                        SizedBox(
                          height: 56.h,
                          child: ElevatedButton.icon(
                            onPressed: submitting
                                ? null
                                : () => cubit.submit(
                                    studentId: widget.student.id,
                                    circleId: widget.student.circle?.id ?? 0,
                                    // TODO: replace with the examiner's active
                                    // cycle id from session/context once the
                                    // cycles endpoint/selection is wired.
                                    cycleId: 1,
                                  ),
                            icon: submitting
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_rounded),
                            label: Text(
                              submitting ? 'جاري الحفظ...' : 'حفظ الاختبار',
                            ),
                          ),
                        ),
                        24.sbH,
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
