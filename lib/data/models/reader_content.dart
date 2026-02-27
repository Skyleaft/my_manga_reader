import 'manga_detail.dart';

class ReaderContent {
  final String mangaId;
  final String mangaTitle;
  final double currentChapterNumber;
  final List<Chapter> allChapters;
  final String chapterTitle;
  final List<String> pageUrls;
  final int currentPage;
  final int totalPages;

  ReaderContent({
    required this.mangaId,
    required this.mangaTitle,
    required this.currentChapterNumber,
    required this.allChapters,
    required this.chapterTitle,
    required this.pageUrls,
    this.currentPage = 1,
  }) : totalPages = pageUrls.length;
}
