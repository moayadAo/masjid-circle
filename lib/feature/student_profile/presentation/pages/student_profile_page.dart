// student_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/feature/student_profile/data_source/model/student_detail_model.dart';
import 'package:masjid/feature/student_profile/presentation/cubit/student_info_cubit.dart';
import 'package:masjid/feature/student_profile/presentation/cubit/student_info_state.dart';
import 'package:masjid/feature/student_profile/presentation/cubit/student_recitations_cubit.dart';
import 'package:masjid/feature/student_profile/widgets/info_row.dart';
import 'package:masjid/feature/student_profile/widgets/phone_row.dart';
import 'package:masjid/feature/student_profile/widgets/student_info_card.dart';
import 'package:masjid/feature/student_profile/widgets/student_profile_header.dart';
import 'package:masjid/feature/student_profile/widgets/student_profile_shimmer.dart';
import 'package:masjid/feature/student_profile/widgets/student_recitations_section.dart';
import 'package:masjid/routing/app_router.dart';

class StudentProfilePage extends StatelessWidget {
  final int studentId;

  const StudentProfilePage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StudentInfoCubit(service: getIt())
                ..loadStudent(studentId: studentId),
        ),
        BlocProvider(
          create: (_) =>
              StudentRecitationsCubit(service: getIt())
                ..loadRecitations(studentId: studentId),
        ),
      ],
      child: _StudentProfileView(studentId: studentId),
    );
  }
}

class _StudentProfileView extends StatefulWidget {
  final int studentId;

  const _StudentProfileView({required this.studentId});

  @override
  State<_StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<_StudentProfileView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 250) {
      context.read<StudentRecitationsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: BlocBuilder<StudentInfoCubit, StudentInfoState>(
          builder: (context, infoState) {
            if (infoState is StudentInfoLoadingState ||
                infoState is StudentInfoInitialState) {
              return const _LoadingScaffold();
            }

            if (infoState is StudentInfoFailureState) {
              return _ErrorScaffold(
                message: infoState.errMessage,
                onRetry: () => context.read<StudentInfoCubit>().loadStudent(
                  studentId: widget.studentId,
                ),
              );
            }

            if (infoState is StudentInfoSuccessState) {
              return _StudentProfileScaffold(
                student: infoState.student,
                studentId: widget.studentId,
                scrollController: _scrollController,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Scaffold variants ─────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: AppColor.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ملف الطالب',
          style: AppTextStyle.headlineMd(
            context,
          ).copyWith(color: AppColor.primary),
        ),
      ),
      body: const StudentProfileShimmer(),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorScaffold({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: AppColor.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ملف الطالب',
          style: AppTextStyle.headlineMd(
            context,
          ).copyWith(color: AppColor.primary),
        ),
      ),
      body: AppErrorWidget(message: message, onRetry: onRetry),
    );
  }
}

class _StudentProfileScaffold extends StatelessWidget {
  final StudentDetailModel student;
  final int studentId;
  final ScrollController scrollController;

  const _StudentProfileScaffold({
    required this.student,
    required this.studentId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColor.surfaceContainerLowest,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.primary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            student.fullName,
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primary, fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          context.read<StudentInfoCubit>().loadStudent(studentId: studentId);
          await context.read<StudentRecitationsCubit>().loadRecitations(
            studentId: studentId,
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile header ────────────────────────────
              StudentProfileHeader(student: student),
              const SizedBox(height: AppSpacing.md),

              // ── Personal info card ────────────────────────
              _PersonalInfoCard(student: student),
              const SizedBox(height: AppSpacing.sm),

              // ── Guardian info card ────────────────────────
              _GuardianInfoCard(student: student),
              const SizedBox(height: AppSpacing.sm),

              // ── Contact card ──────────────────────────────
              _ContactCard(student: student),
              const SizedBox(height: AppSpacing.lg),

              // ── Recitations section ───────────────────────
              StudentRecitationsSection(
                studentId: studentId,
                pageContext: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info card implementations ────────────────────────────────────────────────

class _PersonalInfoCard extends StatelessWidget {
  final StudentDetailModel student;
  const _PersonalInfoCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return StudentInfoCard(
      icon: Icons.person_outline_rounded,
      title: 'المعلومات الشخصية',
      accentColor: AppColor.primaryContainer,
      iconBg: AppColor.primaryFixed,
      iconFg: AppColor.primary,
      children: [
        if (student.nickname != null)
          InfoRow(label: 'الكنية', value: student.nickname!),
        if (student.birthDate != null)
          InfoRow(label: 'تاريخ الميلاد', value: student.birthDate!),
        InfoRow(label: 'المرحلة الدراسية', value: student.schoolGradeLabel),
        if (student.hasAddress)
          InfoRow(label: 'العنوان', value: student.address!),
        if (student.hasNotes) InfoRow(label: 'ملاحظات', value: student.notes!),
      ],
    );
  }
}

class _GuardianInfoCard extends StatelessWidget {
  final StudentDetailModel student;
  const _GuardianInfoCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return StudentInfoCard(
      icon: Icons.family_restroom_rounded,
      title: 'بيانات الأهل',
      accentColor: AppColor.secondary,
      iconBg: AppColor.secondaryContainer,
      iconFg: AppColor.secondary,
      children: [
        InfoRow(label: 'اسم الأب', value: student.fatherName),
        if (student.motherName != null)
          InfoRow(label: 'اسم الأم', value: student.motherName!),
        if (student.hasFatherJob)
          InfoRow(label: 'مهنة الأب', value: student.fatherJob!),
        if (student.guardianStatus != null)
          InfoRow(label: 'الحالة الأسرية', value: student.guardianStatusLabel),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final StudentDetailModel student;
  const _ContactCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final hasAny =
        student.fatherPhone != null ||
        student.motherPhone != null ||
        student.studentPhone != null;

    if (!hasAny) return const SizedBox.shrink();

    return StudentInfoCard(
      icon: Icons.contact_phone_outlined,
      title: 'معلومات التواصل',
      accentColor: AppColor.tertiary,
      iconBg: AppColor.tertiaryFixed,
      iconFg: AppColor.tertiary,
      children: [
        if (student.fatherPhone != null)
          PhoneRow(label: 'جوال الأب', phone: student.fatherPhone!),
        if (student.motherPhone != null)
          PhoneRow(label: 'جوال الأم', phone: student.motherPhone!),
        if (student.studentPhone != null)
          PhoneRow(label: 'جوال الطالب', phone: student.studentPhone!),
      ],
    );
  }
}
