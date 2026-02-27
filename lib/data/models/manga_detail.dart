class MangaDetail {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final String reviewCount;
  final List<String> genres;
  final String synopsis;
  final List<Chapter> chapters;
  final bool isBookmarked;

  MangaDetail({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.genres,
    required this.synopsis,
    required this.chapters,
    this.isBookmarked = false,
  });
}

class Chapter {
  final String title;
  final double chapterNumber;
  final DateTime date;
  final bool isNew;
  final bool isRead;

  Chapter({
    required this.title,
    required this.chapterNumber,
    required this.date,
    this.isNew = false,
    this.isRead = false,
  });
}
