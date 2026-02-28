import 'package:get_it/get_it.dart';
import '../../data/services/library_service.dart';
import '../../data/services/manga_api_service.dart';
import '../../data/services/progression_service.dart';
import '../config/app_config.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  await AppConfig.init();
  getIt.registerLazySingleton<MangaApiService>(() => MangaApiService());
  getIt.registerLazySingleton<ProgressionService>(() => ProgressionService());
  getIt.registerLazySingleton<LibraryService>(() => LibraryService());
}
