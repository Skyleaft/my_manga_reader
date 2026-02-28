import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/manga_detail.dart';
import '../../../data/models/reader_content.dart';
import '../../../data/services/manga_api_service.dart';
import '../../../routes/app_pages.dart';

class MangaDetailScreen extends StatefulWidget {
  final MangaDetail manga;

  const MangaDetailScreen({super.key, required this.manga});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  final MangaApiService _apiService = getIt<MangaApiService>();
  List<Chapter> _chapters = [];
  bool _isLoadingChapters = true;

  MangaDetail get manga => widget.manga;

  @override
  void initState() {
    super.initState();
    _chapters = widget.manga.chapters;
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    try {
      final chaptersData = await _apiService.getMangaChapters(manga.id);
      if (mounted) {
        setState(() {
          _chapters = chaptersData.map((e) => Chapter.fromMap(e)).toList();
          _isLoadingChapters = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingChapters = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient
          _buildHeroSection(context),

          // Scrollable Content
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
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
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
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
                          _buildChapterListHeader(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildChapterListSliver(context, isDark),
              SliverToBoxAdapter(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                  ),
                ),
              ),
            ],
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
          allChapters: _chapters,
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
            Row(
              children: [
                if (manga.url != null)
                  _buildRoundIconButton(
                    icon: Icons.public,
                    onPressed: () => launchUrlString(manga.url!),
                  ),
                const SizedBox(width: 8),
                _buildRoundIconButton(icon: Icons.share, onPressed: () {}),
              ],
            ),
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
            onPressed: _isLoadingChapters
                ? null
                : () {
                    final availableChapters = _chapters
                        .where((c) => c.isChapterAvailable)
                        .toList();
                    if (availableChapters.isNotEmpty) {
                      // Assuming last is first chapter (earliest)
                      final firstAvailable = availableChapters.last;
                      _navigateToReader(
                        context,
                        firstAvailable.chapterNumber,
                        firstAvailable.title,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isLoadingChapters
                  ? Colors.grey[700]
                  : _chapters.any((c) => c.isChapterAvailable)
                  ? AppColors.primary
                  : Colors.grey[700],
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

  Widget _buildChapterListHeader(BuildContext context) {
    return Row(
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
        Row(
          children: [
            IconButton(
              onPressed: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scraping chapters...')),
                  );
                  await _apiService.scrapChapterPages(manga.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chapter scraping queued successfully!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to scrap chapters: $e')),
                    );
                  }
                }
              },
              icon: const Icon(
                Icons.cloud_download_outlined,
                color: AppColors.primary,
                size: 20,
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
      ],
    );
  }

  Widget _buildChapterListSliver(BuildContext context, bool isDark) {
    final bgColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    if (_isLoadingChapters) {
      return SliverToBoxAdapter(
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.all(24.0),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_chapters.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.all(24.0),
          child: const Center(
            child: Text(
              'No chapters available',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final chapter = _chapters[index];
        return Container(
          color: bgColor,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: _buildChapterItem(context, chapter, isDark),
        );
      }, childCount: _chapters.length),
    );
  }

  Widget _buildChapterItem(BuildContext context, Chapter chapter, bool isDark) {
    final bool isAvailable = chapter.isChapterAvailable;

    return InkWell(
      onTap: isAvailable
          ? () =>
                _navigateToReader(context, chapter.chapterNumber, chapter.title)
          : null,
      borderRadius: BorderRadius.circular(36),
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.6,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: isAvailable
                ? AppColors.backgroundLight.withValues(
                    blue: 20,
                    red: 15,
                    green: 15,
                  )
                : Colors.grey.shade600,
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
                      color: AppColors.backgroundDark,
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
              if (!isAvailable)
                _buildStatusBadge('SOON', Colors.grey[700]!, Colors.white70)
              else if (chapter.isNew)
                _buildStatusBadge('NEW', AppColors.primary, Colors.white)
              else if (chapter.isRead)
                _buildStatusBadge('READ', Colors.grey[700]!, Colors.grey[400]!)
              else
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
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
