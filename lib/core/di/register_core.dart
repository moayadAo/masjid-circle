import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart'; // ← أضف هذا الـ import
import 'package:masjid/core/network/api/api_consumer.dart';
import 'package:masjid/core/network/api/dio_consumer.dart';
import 'package:masjid/core/storage/hive_helper.dart';

Future<void> registerCore(GetIt getIt) async {
  getIt.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    ),
  );

  // Hive
  getIt.registerLazySingleton<HiveHelper>(HiveHelper.new);

  // Network
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: Dio()));
}
