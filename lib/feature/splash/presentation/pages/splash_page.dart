import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward();

    // Navigate after splash duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003527),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF003527),
                  const Color(0xFF003527).withOpacity(0.95),
                ],
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),

                // Logo and title section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // App Icon
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFA6F2D1,
                                ).withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28.r),
                            child: SvgPicture.asset(
                              'assets/logo/logo_Transparent.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // App Name
                        Text(
                          'أثر',
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFA6F2D1),
                            fontFamily: 'NotoSansArabic',
                            letterSpacing: 1.5.w,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Tagline
                        Text(
                          'أثرٌ يبقى.. وعملٌ يرقى',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA6F2D1).withOpacity(0.8),
                            fontFamily: 'NotoSansArabic',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),

                        // Loading bar
                        _buildLoadingBar(),
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: EdgeInsets.only(bottom: 32.h),
                  child: Column(
                    children: [
                      // Subtitle badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6F2D1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFFA6F2D1).withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: const Color(0xFFA6F2D1),
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'نظام إدارة الحلقات',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFA6F2D1),
                                fontFamily: 'NotoSansArabic',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Version text
                      Text(
                        'الإصدار ١.٠',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFA6F2D1).withOpacity(0.6),
                          fontFamily: 'NotoSansArabic',
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: 140.w,
              height: 2.h,
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFA6F2D1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
                  // Animated progress
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(
                        (_animationController.value * 280.w) - 140.w,
                        0,
                      ),
                      child: Container(
                        width: 70.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6F2D1),
                          borderRadius: BorderRadius.circular(1.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA6F2D1).withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
