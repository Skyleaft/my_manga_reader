import 'package:shared_preferences/shared_preferences.dart';
import '../models/library_manga.dart';
import 'progression_service.dart';

class LibraryService {
  static const _libraryKey = 'manga_library';

  Future<void> addToLibrary(LibraryManga manga) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final library = await getAllLibraryMangas();

      // Check if manga already exists in library
      final existingIndex = library.indexWhere((m) => m.id == manga.id);

      if (existingIndex >= 0) {
        // Update existing manga
        library[existingIndex] = manga;
      } else {
        // Add new manga
        library.add(manga);
      }

      // Save back to preferences
      final jsonList = library.map((m) => m.toJson()).toList();
      await prefs.setStringList(_libraryKey, jsonList);
    } catch (e) {
      // Handle serialization or storage errors
      throw Exception('Failed to add manga to library: $e');
    }
  }

  Future<void> removeFromLibrary(String mangaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final library = await getAllLibraryMangas();

      library.removeWhere((m) => m.id == mangaId);

      final jsonList = library.map((m) => m.toJson()).toList();
      await prefs.setStringList(_libraryKey, jsonList);
    } catch (e) {
      // Handle storage errors
      throw Exception('Failed to remove manga from library: $e');
    }
  }

  Future<LibraryManga?> getLibraryManga(String mangaId) async {
    final library = await getAllLibraryMangas();
    return library.firstWhereOrNull((m) => m.id == mangaId);
  }

  Future<List<LibraryManga>> getAllLibraryMangas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_libraryKey) ?? [];

      return jsonList.map((json) => LibraryManga.fromJson(json)).toList();
    } catch (e) {
      // Handle parsing or storage errors
      throw Exception('Failed to load library: $e');
    }
  }

  Future<bool> isInLibrary(String mangaId) async {
    final library = await getAllLibraryMangas();
    return library.any((m) => m.id == mangaId);
  }

  Future<void> updateMangaProgress(
    String mangaId,
    double currentChapter,
    int currentPage,
    int totalPages,
    bool isCompleted,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final library = await getAllLibraryMangas();

    final mangaIndex = library.indexWhere((m) => m.id == mangaId);

    if (mangaIndex >= 0) {
      library[mangaIndex] = library[mangaIndex].copyWith(
        currentChapter: currentChapter,
        currentPage: currentPage,
        totalPages: totalPages,
        isCompleted: isCompleted,
      );

      final jsonList = library.map((m) => m.toJson()).toList();
      await prefs.setStringList(_libraryKey, jsonList);
    }
  }

  Future<void> clearLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_libraryKey);
  }
}
