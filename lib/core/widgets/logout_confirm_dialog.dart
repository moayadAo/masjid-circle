import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/widgets/loading_indicator.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_state.dart';
import 'package:masjid/routing/app_router.dart';

Future<bool> showLogoutConfirmDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => const _LogoutConfirmDialog(),
  );

  return result ?? false;
}

class _LogoutConfirmDialog extends StatelessWidget {
  const _LogoutConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          AppToast.success(context, 'تم تسجيل الخروج بنجاح');
          context.go(Routes.login);
        } else if (state is LogoutFailureState) {
          AppToast.error(context, state.errMessage);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColor.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColor.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withOpacity(0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColor.errorContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.error.withOpacity(0.14),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColor.error,
                    size: 34,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'تسجيل الخروج',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.headlineMd(
                    context,
                  ).copyWith(color: AppColor.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'هل تريد تسجيل الخروج من حسابك الآن؟',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMd(
                    context,
                  ).copyWith(color: AppColor.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColor.outlineVariant,
                          ),
                          foregroundColor: AppColor.primary,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: AppTextStyle.labelLg(
                            context,
                            AppColor.primary,
                            15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return state is LogoutLoadingState
                              ? const LoadingIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().logout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.error,
                                    foregroundColor: AppColor.onError,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'تسجيل الخروج',
                                    style: AppTextStyle.labelLg(
                                      context,
                                      AppColor.onError,
                                      15,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
