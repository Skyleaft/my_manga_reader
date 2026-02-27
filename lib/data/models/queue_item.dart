class QueueItem {
  final String id;
  final String mangaTitle;
  final double chapterNumber;
  final String status;
  final DateTime queuedAt;

  QueueItem({
    required this.id,
    required this.mangaTitle,
    required this.chapterNumber,
    required this.status,
    required this.queuedAt,
  });

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    return QueueItem(
      id: json['id'] as String,
      mangaTitle: json['mangaTitle'] as String,
      chapterNumber: (json['chapterNumber'] as num).toDouble(),
      status: json['status'] as String,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
    );
  }
}
