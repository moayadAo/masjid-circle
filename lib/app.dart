import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_theme.dart';
import 'package:masjid/routing/app_router.dart';
import 'package:masjid/shared/app_providers/app_providers.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilBootstrap.init(
      builder: (_, __) {
        return MultiBlocProvider(
          providers: appProviders,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: buildAppTheme(),
          ),
        );
      },
    );
  }
}
