import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masjid/core/design_app/app_toast/app_toast.dart';
import 'package:masjid/core/design_app/spacing_system/icon_sizes.dart';
import 'package:masjid/core/design_app/spacing_system/radius.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/design_app/spacing_system/spacing.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/storage/hive_boxes.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/core/storage/hive_key.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_state.dart';
import 'package:masjid/feature/auth/widgets/login_form_widget.dart';
import 'package:masjid/feature/auth/widgets/login_header_widget.dart';
import 'package:masjid/routing/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleStateChanges(
    BuildContext context,
    AuthState state,
  ) async {
    if (state is LoginSuccessState) {
      AppToast.success(context, 'تم تسجيل الدخول بنجاح');
      final roles = state.authData.roles;
      final isAssistant = roles.contains('assistant_teacher');
      final role = isAssistant ? 'assistant' : 'main';

      // Persist role for router redirect on cold start
      await getIt<HiveHelper>().saveData(
        HiveBoxes.appBox,
        HiveKey.userRole,
        role,
      );

      if (!context.mounted) return;

      if (isAssistant) {
        context.go(Routes.generalRecitation);
      } else {
        context.go(Routes.myCircles);
      }
      // context.go('/home');
    } else if (state is LoginFailureState) {
      AppToast.error(context, state.errMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: BlocListener<AuthCubit, AuthState>(
          listener: _handleStateChanges,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ── Mosque Header ──
                      const LoginHeaderWidget(),

                      // ── Form Section ──
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            // Logo + title
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColor.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.menu_book,
                                color: AppColor.primaryContainer,
                                size: AppIconSize.lg,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'تسجيل الدخول',
                              style: AppTextStyle.headlineMd(
                                context,
                              ).copyWith(color: AppColor.primary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'مرحباً بك مجدداً في بوابة المعلم',
                              style: AppTextStyle.bodyMd(
                                context,
                              ).copyWith(color: AppColor.outline),
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // Form
                            LoginFormWidget(
                              formKey: _formKey,
                              usernameController: _usernameController,
                              passwordController: _passwordController,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            const SizedBox(height: AppSpacing.md),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
