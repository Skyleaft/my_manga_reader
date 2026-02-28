class MangaSummary {
  final String id;
  final String title;
  final String author;
  final String type;
  final List<String>? genres;
  final String? description;
  final String? imageUrl;
  final String? localImageUrl;
  final String? status;
  final int totalView;
  final LatestChapterSummary? latestChapter;

  MangaSummary({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    this.genres,
    this.description,
    this.imageUrl,
    this.localImageUrl,
    this.status,
    required this.totalView,
    this.latestChapter,
  });

  factory MangaSummary.fromJson(Map<String, dynamic> json) {
    return MangaSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      type: json['type'] as String,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImageUrl: json['localImageUrl'] as String?,
      status: json['status'] as String?,
      totalView: json['totalView'] as int? ?? 0,
      latestChapter: json['latestChapter'] != null
          ? LatestChapterSummary.fromJson(
              json['latestChapter'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String get displayImageUrl {
    if (localImageUrl != null && localImageUrl!.isNotEmpty) {
      // Assuming the base URL is the same as the API
      // We will handle the base URL in the service or configuration
      return localImageUrl!;
    }
    return imageUrl ?? '';
  }
}

class LatestChapterSummary {
  final String id;
  final num number;
  final int totalView;
  final DateTime uploadDate;

  LatestChapterSummary({
    required this.id,
    required this.number,
    required this.totalView,
    required this.uploadDate,
  });

  factory LatestChapterSummary.fromJson(Map<String, dynamic> json) {
    return LatestChapterSummary(
      id: json['id'] as String,
      number: json['number'] as num? ?? 0,
      totalView: json['totalView'] as int? ?? 0,
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'] as String)
          : DateTime.now(),
    );
  }
}
