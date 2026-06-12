// _recitation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid/feature/home/main_teacher_nav_bar.dart';

import '../../../../core/design_app/app_toast/app_toast.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../routing/routes.dart';
import '../../data/remote/recitation_service.dart';
import '../../widgets/or_divider.dart';
import '../../widgets/qr_scan_card.dart';
import '../../widgets/recitation_app_bar.dart';
import '../../widgets/recitation_header_section.dart';
import '../../widgets/recitation_submit_button.dart';
import '../../widgets/student_id_input_field.dart';
import '../cubit/recitation_cubit.dart';
import '../cubit/recitation_state.dart';

class RecitationPage extends StatelessWidget {
  const RecitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecitationCubit(service: getIt<RecitationService>()),
      child: const _RecitationView(),
    );
  }
}

class _RecitationView extends StatefulWidget {
  const _RecitationView();

  @override
  State<_RecitationView> createState() => _RecitationViewState();
}

class _RecitationViewState extends State<_RecitationView> {
  final TextEditingController _studentIdController = TextEditingController();
  // int _navIndex = 0;

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  void _onCodeReady(String code) {
    context.read<RecitationCubit>().lookupStudent(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: const RecitationAppBar(),
      body: BlocConsumer<RecitationCubit, RecitationState>(
        listener: (context, state) {
          if (state is RecitationFailure) {
            AppToast.error(context, state.errMessage);
          } else if (state is RecitationSuccess) {
            AppToast.success(
              context,
              'تم العثور على الطالب: ${state.data.student.fullName}',
            );
            context.push(
              Routes.recitationForm,
              extra: {
                'studentId': state.data.student.id,
                'studentName': state.data.student.fullName,
                'circleId': state.data.circle.id,
                'cycleId': state.data.cycle.id,
              },
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RecitationLoading;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const RecitationHeaderSection(),
                  AppSpacing.lg.sbH,
                  QrScanCard(onCodeScanned: _onCodeReady),
                  AppSpacing.lg.sbH,
                  const OrDivider(),
                  AppSpacing.lg.sbH,
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StudentIdInputField(controller: _studentIdController),
                        AppSpacing.md.sbH,
                        RecitationSubmitButton(
                          isLoading: isLoading,
                          onPressed: () =>
                              _onCodeReady(_studentIdController.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const MainTeacherNavBar(currentIndex: 1),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _navIndex,
      //   items: [],
      //   onTap: (index) => setState(() => _navIndex = index),
      // ),
    );
  }
}
