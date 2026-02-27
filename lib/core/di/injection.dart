import 'package:get_it/get_it.dart';
import '../../data/services/manga_api_service.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerLazySingleton<MangaApiService>(() => MangaApiService());
}
