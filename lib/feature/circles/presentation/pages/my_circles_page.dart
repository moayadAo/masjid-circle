import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/core/widgets/logout_confirm_dialog.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_state.dart';
import 'package:masjid/feature/circles/widgets/circle_card_widget.dart';
import 'package:masjid/feature/home/main_teacher_nav_bar.dart';
import 'package:masjid/routing/app_router.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/circles/widgets/circle_card_shimmer.dart';

class MyCirclesPage extends StatefulWidget {
  const MyCirclesPage({super.key});
  @override
  State<MyCirclesPage> createState() => _MyCirclesPageState();
}

class _MyCirclesPageState extends State<MyCirclesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CirclesCubit>().getMyCircles();
  }

  Future<void> _handleLogoutPressed() async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!mounted || !shouldLogout) return;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.surfaceContainerLowest,
          elevation: 0,
          title: Text(
            'حلقاتي',
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primary),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColor.primary),
              onPressed: _handleLogoutPressed,
            ),
          ],
        ),
        body: BlocBuilder<CirclesCubit, CirclesState>(
          buildWhen: (_, state) =>
              state is GetCirclesLoadingState ||
              state is GetCirclesSuccessState ||
              state is GetCirclesFailureState,
          builder: (context, state) {
            if (state is GetCirclesLoadingState) {
              return const CircleListShimmer();
            }
            if (state is GetCirclesFailureState) {
              return AppErrorWidget(
                message: state.errMessage,
                onRetry: () => context.read<CirclesCubit>().getMyCircles(),
              );
            }
            if (state is GetCirclesSuccessState) {
              if (state.circles.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد حلقات مسندة إليك',
                    style: AppTextStyle.bodyLg(
                      context,
                    ).copyWith(color: AppColor.outline),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<CirclesCubit>().getMyCircles(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: state.circles.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) => CircleCardWidget(
                    circle: state.circles[i],
                    onTap: () => context.push(
                      Routes.circleDetailsPath(state.circles[i].id),
                      extra: state.circles[i].name,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: const MainTeacherNavBar(currentIndex: 0),
      ),
    );
  }
}
