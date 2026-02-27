import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/manga_detail.dart';
import '../../../data/models/reader_content.dart';
import '../../../data/services/manga_api_service.dart';
import '../../../routes/app_pages.dart';

class MangaDetailScreen extends StatelessWidget {
  final MangaDetail manga;
  final MangaApiService _apiService = getIt<MangaApiService>();

  MangaDetailScreen({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient
          _buildHeroSection(context),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 300), // Offset for hero
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainInfo(isDark),
                      const SizedBox(height: 16),
                      _buildGenreTags(),
                      const SizedBox(height: 24),
                      _buildSynopsis(),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                      const SizedBox(height: 32),
                      _buildChapterList(context, isDark),
                      const SizedBox(height: 48), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Navigation Bar
          _buildTopNav(context),
        ],
      ),
    );
  }

  Future<void> _navigateToReader(
    BuildContext context,
    double chapterNumber,
    String chapterTitle,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final pages = await _apiService.getChapterPages(manga.id, chapterNumber);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        final content = ReaderContent(
          mangaId: manga.id,
          mangaTitle: manga.title,
          currentChapterNumber: chapterNumber,
          allChapters: manga.chapters,
          chapterTitle: chapterTitle,
          pageUrls: pages
              .map(
                (p) => _apiService.getLocalImageUrl(
                  p['localImageUrl'] as String?,
                  p['imageUrl'] as String?,
                ),
              )
              .toList(),
        );

        Navigator.pushNamed(context, AppRoutes.reader, arguments: content);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load chapter: $e')));
      }
    }
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(manga.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.4),
              AppColors.backgroundDark.withOpacity(0.8),
              AppColors.backgroundDark,
            ],
            stops: const [0.0, 0.4, 0.8, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRoundIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            _buildRoundIconButton(icon: Icons.share, onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMainInfo(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manga.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'By ${manga.author}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.primary, size: 20),
                const SizedBox(width: 4),
                Text(
                  manga.rating.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Text(
              manga.reviewCount,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...manga.genres.map(
          (genre) => _buildTag(
            genre,
            AppColors.primary.withOpacity(0.2),
            AppColors.primary,
          ),
        ),
        _buildTag('ONGOING', Colors.grey.withOpacity(0.2), Colors.grey),
      ],
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSynopsis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Synopsis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          manga.synopsis,
          style: const TextStyle(color: Colors.grey, height: 1.6, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton.icon(
            onPressed: () {
              if (manga.chapters.isNotEmpty) {
                final firstChapter = manga.chapters.last;
                _navigateToReader(
                  context,
                  firstChapter.chapterNumber,
                  firstChapter.title,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            icon: const Icon(Icons.menu_book),
            label: const Text(
              'Read First Chapter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 56,
          width: 64,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(36),
          ),
          child: IconButton(
            icon: const Icon(Icons.library_add, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildChapterList(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chapters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Text(
                'Sort',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              label: const Icon(
                Icons.swap_vert,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: manga.chapters.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final chapter = manga.chapters[index];
            return _buildChapterItem(context, chapter, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildChapterItem(BuildContext context, Chapter chapter, bool isDark) {
    return InkWell(
      onTap: () =>
          _navigateToReader(context, chapter.chapterNumber, chapter.title),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey[800]!.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${chapter.date.year}-${chapter.date.month.toString().padLeft(2, '0')}-${chapter.date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 189, 189),
                  ),
                ),
              ],
            ),
            if (chapter.isNew)
              _buildStatusBadge('NEW', AppColors.primary, Colors.white)
            else if (chapter.isRead)
              _buildStatusBadge('READ', Colors.grey[700]!, Colors.grey[400]!)
            else
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
