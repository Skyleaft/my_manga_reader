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
