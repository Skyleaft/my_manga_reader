import 'dart:convert';

class MangaProgression {
  final String mangaId;
  final double currentChapter;
  final int currentPage;
  final int totalPages;
  final DateTime lastRead;
  final bool isCompleted;

  MangaProgression({
    required this.mangaId,
    required this.currentChapter,
    required this.currentPage,
    required this.totalPages,
    required this.lastRead,
    required this.isCompleted,
  });

  factory MangaProgression.fromMap(Map<String, dynamic> map) {
    return MangaProgression(
      mangaId: map['mangaId'] as String,
      currentChapter: (map['currentChapter'] as num).toDouble(),
      currentPage: map['currentPage'] as int,
      totalPages: map['totalPages'] as int,
      lastRead: DateTime.parse(map['lastRead'] as String),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mangaId': mangaId,
      'currentChapter': currentChapter,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'lastRead': lastRead.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory MangaProgression.fromJson(String source) =>
      MangaProgression.fromMap(jsonDecode(source) as Map<String, dynamic>);

  MangaProgression copyWith({
    String? mangaId,
    double? currentChapter,
    int? currentPage,
    int? totalPages,
    DateTime? lastRead,
    bool? isCompleted,
  }) {
    return MangaProgression(
      mangaId: mangaId ?? this.mangaId,
      currentChapter: currentChapter ?? this.currentChapter,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      lastRead: lastRead ?? this.lastRead,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progressPercentage {
    if (totalPages <= 0) return 0.0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }
}
