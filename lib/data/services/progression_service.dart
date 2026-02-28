import 'package:shared_preferences/shared_preferences.dart';
import '../models/progression.dart';

extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class ProgressionService {
  static const _progressionKey = 'manga_progression';

  Future<void> saveProgression(MangaProgression progression) async {
    final prefs = await SharedPreferences.getInstance();
    final progressions = await getAllProgressions();

    // Find existing progression for this manga and chapter
    final existingIndex = progressions.indexWhere(
      (p) =>
          p.mangaId == progression.mangaId &&
          p.currentChapter == progression.currentChapter,
    );

    if (existingIndex >= 0) {
      // Update existing progression for this chapter
      progressions[existingIndex] = progression;
    } else {
      // New progression
      progressions.add(progression);
    }

    // Save back to preferences
    final jsonList = progressions.map((p) => p.toJson()).toList();
    await prefs.setStringList(_progressionKey, jsonList);
  }

  Future<MangaProgression?> getProgression(String mangaId) async {
    final progressions = await getAllProgressions();
    return progressions.firstWhereOrNull((p) => p.mangaId == mangaId);
  }

  Future<List<MangaProgression>> getAllProgressions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_progressionKey) ?? [];

    return jsonList.map((json) => MangaProgression.fromJson(json)).toList();
  }

  Future<void> deleteProgression(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final progressions = await getAllProgressions();

    progressions.removeWhere((p) => p.mangaId == mangaId);

    final jsonList = progressions.map((p) => p.toJson()).toList();
    await prefs.setStringList(_progressionKey, jsonList);
  }

  Future<void> clearAllProgressions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressionKey);
  }
}
