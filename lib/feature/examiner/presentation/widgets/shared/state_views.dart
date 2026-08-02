import 'package:masjid/core/constant/export_theme_files.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColor.primary),
    );
  }
}

class ErrorRetryView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColor.error,
              size: 48.sp,
            ),
            12.sbH,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMd(context),
            ),
            16.sbH,
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                color: AppColor.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44.sp, color: AppColor.outlineVariant),
            ),
            16.sbH,
            Text(title, style: AppTextStyle.headlineMd(context)),
            8.sbH,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMd(
                context,
              ).copyWith(color: AppColor.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
