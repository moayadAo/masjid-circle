import 'package:masjid/core/constant/export_theme_files.dart';

/// Big primary action to launch the QR scanner.
/// Wire [onTap] to your scanner package of choice (e.g. mobile_scanner),
/// then feed the decoded string into ExaminerStudentsCubit.lookupByBarcode.
class QrScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const QrScanButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.primary,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AppColor.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColor.onPrimaryContainer,
                  size: 36.sp,
                ),
              ),
              12.sbH,
              Text(
                'بدء مسح QR',
                style: AppTextStyle.headlineMd(
                  context,
                ).copyWith(color: AppColor.onPrimary),
              ),
              4.sbH,
              Text(
                'امسح بطاقة الطالب لبدء الاختبار فوراً',
                style: AppTextStyle.labelLg(
                  context,
                  AppColor.onPrimary.withOpacity(0.8),
                  13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
