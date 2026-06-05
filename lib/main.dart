import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masjid/app.dart';
import 'package:masjid/core/bloc_state/bloc_observer_app.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/user_session/user_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await initServiceLocator();
  Bloc.observer = MyCubitObserver();
  await UserSession.init();

  runApp(App());
}
