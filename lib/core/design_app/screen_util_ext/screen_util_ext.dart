import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenUtilNumExt on num {
  /// Responsive width based on device width
  double get w => ScreenUtil().setWidth(this);

  /// Responsive height based on device height
  double get h => ScreenUtil().setHeight(this);

  /// Responsive font size
  double get sp => ScreenUtil().setSp(this);

  /// Responsive radius
  double get r => ScreenUtil().radius(this);

  /// Convenient SizedBox helpers
  SizedBox get sbW => SizedBox(width: w);
  SizedBox get sbH => SizedBox(height: h);
}

extension ScreenUtilContextExt on BuildContext {
  /// Screen width
  double get sw => ScreenUtil().screenWidth;

  /// Screen height
  double get sh => ScreenUtil().screenHeight;

  /// Status bar height (top padding)
  double get statusBar => ScreenUtil().statusBarHeight;

  /// Bottom safe area (gesture/navigation bar)
  double get bottomBar => ScreenUtil().bottomBarHeight;

  /// Quick checks (تقريبية ومفيدة)
  bool get isSmallPhone => sw < 360;
  bool get isPhone => sw < 600;
  bool get isTablet => sw >= 600;
}

class ScreenUtilBootstrap {
  static const Size designSize = Size(440, 956);

  static ScreenUtilInit init({
    required Widget Function(BuildContext, Widget?) builder,
    Widget? child,
  }) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: builder,
      child: child,
    );
  }
}
