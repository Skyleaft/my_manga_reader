import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../core/widgets/manga_card.dart';
import '../../../data/models/library_manga.dart';
import '../../../data/models/manga_detail.dart';
import '../../../data/services/library_service.dart';
import '../../../data/services/manga_api_service.dart';
import '../../../routes/app_pages.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final LibraryService _libraryService = getIt<LibraryService>();
  final MangaApiService _apiService = getIt<MangaApiService>();
  List<LibraryManga> _libraryMangas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      final libraryMangas = await _libraryService.getAllLibraryMangas();
      if (mounted) {
        setState(() {
          _libraryMangas = libraryMangas;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor:
                (isDark ? AppColors.backgroundDark : AppColors.backgroundLight)
                    .withOpacity(0.8),
            surfaceTintColor: Colors.transparent,
            expandedHeight: 220,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: _buildHeader(context, isDark),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
            sliver: _buildContent(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Library',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.history);
                },
                icon: const Icon(Icons.history_outlined),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey[200]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search in library',
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Reading', false),
                _buildFilterChip('Completed', false),
                _buildFilterChip('Planned', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : Colors.grey[200]!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          padding: const EdgeInsets.all(24.0),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_libraryMangas.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          padding: const EdgeInsets.all(24.0),
          child: const Center(
            child: Text(
              'Your library is empty\nAdd some manga to get started!',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final manga = _libraryMangas[index];
        return MangaCard(
          title: manga.title,
          imageUrl: manga.imageUrl,
          currentChapter: manga.currentChapter.toInt(),
          totalChapters: 0, // Library manga doesn't track total chapters
          progress: manga.progressPercentage,
          isCompleted: manga.isCompleted,
          type: manga.type, // Use the type from library manga
          status: manga.isCompleted ? 'COMPLETED' : 'READING',
          genres: [], // Library doesn't track genres
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            try {
              final detailData = await _apiService.getMangaDetail(manga.id);
              if (!mounted) return;
              Navigator.pop(context); // Close loading dialog

              final mangaDetail = MangaDetail.fromMap(
                detailData,
                imageUrl: _apiService.getLocalImageUrl(
                  detailData['localImageUrl'] as String?,
                  detailData['imageUrl'] as String?,
                ),
              );

              Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: mangaDetail,
              );
            } catch (e) {
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load details: $e')),
              );
            }
          },
        );
      }, childCount: _libraryMangas.length),
    );
  }
}
