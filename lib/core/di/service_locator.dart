import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:masjid/core/di/register_blocs.dart';
import 'package:masjid/core/di/register_core.dart';
import 'package:masjid/core/di/register_services.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  await registerCore(getIt);
  registerServices(getIt);
  registerBlocs(getIt);
}
