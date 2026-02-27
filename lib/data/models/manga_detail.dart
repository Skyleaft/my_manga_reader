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
  final String? url;

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
    this.url,
  });

  factory MangaDetail.fromMap(
    Map<String, dynamic> map, {
    required String imageUrl,
  }) {
    return MangaDetail(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Unknown Title',
      author: map['author'] as String? ?? 'Unknown Author',
      imageUrl: imageUrl,
      rating: 4.8, // Placeholder as per API response missing rating
      reviewCount: '1.2k reviews', // Placeholder
      genres:
          (map['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      synopsis: map['description'] as String? ?? 'No description available',
      chapters:
          (map['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      isBookmarked: false,
      url: map['url'] as String?,
    );
  }
}

class Chapter {
  final String title;
  final double chapterNumber;
  final DateTime date;
  final bool isNew;
  final bool isRead;
  final bool isChapterAvailable;

  final String? link;

  Chapter({
    required this.title,
    required this.chapterNumber,
    required this.date,
    this.isNew = false,
    this.isRead = false,
    this.isChapterAvailable = true,
    this.link,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      title: 'Chapter ${map['number']}',
      chapterNumber: (map['number'] as num?)?.toDouble() ?? 0.0,
      date: map['uploadDate'] != null
          ? DateTime.parse(map['uploadDate'] as String)
          : DateTime.now(),
      isNew: false,
      isRead: false,
      isChapterAvailable: map['isChapterAvailable'] as bool? ?? true,
      link: map['link'] as String?,
    );
  }
}
