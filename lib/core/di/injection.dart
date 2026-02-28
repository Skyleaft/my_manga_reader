import 'package:get_it/get_it.dart';
import '../../data/services/manga_api_service.dart';
import '../config/app_config.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  await AppConfig.init();
  getIt.registerLazySingleton<MangaApiService>(() => MangaApiService());
}
