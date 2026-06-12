import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';

class LoadingIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? 30,
        width: width ?? 30,
        child: CircularProgressIndicator(
          backgroundColor: backgroundColor ?? AppColor.primary.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation(color ?? AppColor.primary),
        ),
      ),
    );
  }
}
