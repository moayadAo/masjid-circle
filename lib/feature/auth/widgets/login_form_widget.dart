import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/design_app/spacing_system/icon_sizes.dart';
import 'package:masjid/core/design_app/spacing_system/radius.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/design_app/spacing_system/spacing.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_state.dart';
import 'package:masjid/feature/auth/widgets/auth_text_field.dart';
import 'package:masjid/feature/auth/widgets/login_button.dart';

class LoginFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Username
          AuthTextField(
            controller: widget.usernameController,
            hintText: 'اسم المستخدم',
            suffixIcon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اسم المستخدم مطلوب' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // Password
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (_, state) => state is TogglePasswordVisibilityState,
            builder: (context, state) {
              final isVisible = context.read<AuthCubit>().isPasswordVisible;
              return AuthTextField(
                controller: widget.passwordController,
                hintText: 'كلمة المرور',
                // prefixIcon: Icons.lock_outline,
                obscureText: !isVisible,

                suffixWidget: GestureDetector(
                  onTap: () =>
                      context.read<AuthCubit>().togglePasswordVisibility(),
                  child: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColor.outline,
                    size: AppIconSize.md,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'كلمة المرور مطلوبة' : null,
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Remember me + Forgot password
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Forgot password
          //     GestureDetector(
          //       onTap: () {
          //         // TODO: navigate to forgot password
          //       },
          //       child: Text(
          //         'نسيت كلمة المرور؟',
          //         style: AppTextStyle.bodyMd(context).copyWith(
          //           color: AppColor.primaryContainer,
          //           decoration: TextDecoration.underline,
          //         ),
          //       ),
          //     ),
          //     // Remember me
          //     Row(
          //       children: [
          //         Text(
          //           'تذكرني',
          //           style: AppTextStyle.bodyMd(
          //             context,
          //           ).copyWith(color: AppColor.outline),
          //         ),
          //         const SizedBox(width: AppSpacing.xs),
          //         Checkbox(
          //           value: _rememberMe,
          //           onChanged: (v) => setState(() => _rememberMe = v ?? false),
          //           activeColor: AppColor.primaryContainer,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(AppRadius.xs),
          //           ),
          //           side: const BorderSide(color: AppColor.outline),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          const SizedBox(height: AppSpacing.lg),

          // Login button
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (_, state) =>
                state is LoginLoadingState ||
                state is LoginSuccessState ||
                state is LoginFailureState,
            builder: (context, state) {
              return LoginButton(
                isLoading: state is LoginLoadingState,
                onPressed: () {
                  if (widget.formKey.currentState?.validate() ?? false) {
                    context.read<AuthCubit>().login(
                      username: widget.usernameController.text.trim(),
                      password: widget.passwordController.text,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
