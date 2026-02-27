import 'package:dio/dio.dart';
import '../../core/config/app_config.dart';
import '../models/manga_summary.dart';
import '../models/paged_response.dart';

class MangaApiService {
  final Dio _dio;

  MangaApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  Future<PagedResponse<MangaSummary>> getPagedManga({
    String? search,
    List<String>? genres,
    String? status,
    String? type,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/manga/paged',
        queryParameters: {
          if (search != null) 'search': search,
          if (genres != null && genres.isNotEmpty) 'genres': genres,
          if (status != null) 'status': status,
          if (type != null) 'type': type,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return PagedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MangaSummary.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMangaDetail(String mangaId) async {
    try {
      final response = await _dio.get('/api/manga/$mangaId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getChapterPages(
    String mangaId,
    double chapterNumber,
  ) async {
    try {
      final response = await _dio.get(
        '/api/manga/$mangaId/chapter/$chapterNumber',
      );
      return (response.data as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppConfig.baseUrl}$path';
  }

  String getLocalImageUrl(String? localPath, String? remotePath) {
    if (localPath == null || localPath.isEmpty) {
      return getImageUrl(remotePath);
    }
    if (localPath.startsWith('http')) return localPath;

    // If it already includes the full path including endpoint
    if (localPath.startsWith('/api/images/')) {
      return '${AppConfig.baseUrl}$localPath';
    }

    return '${AppConfig.baseUrl}/api/images$localPath';
  }

  Future<void> scrapManga(String mangaUrl, bool scrapChapters) async {
    try {
      await _dio.post(
        '/api/scrapper/manga',
        data: {'mangaUrl': mangaUrl, 'scrapChapters': scrapChapters},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getScrapQueue() async {
    try {
      final response = await _dio.get('/api/scrapper/queue');
      return (response.data as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
