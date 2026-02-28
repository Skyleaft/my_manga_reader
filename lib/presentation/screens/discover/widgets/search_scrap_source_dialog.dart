import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../data/services/manga_api_service.dart';

class SearchScrapSourceDialog extends StatefulWidget {
  final VoidCallback onScrapped;

  const SearchScrapSourceDialog({super.key, required this.onScrapped});

  @override
  State<SearchScrapSourceDialog> createState() =>
      _SearchScrapSourceDialogState();
}

class _SearchScrapSourceDialogState extends State<SearchScrapSourceDialog> {
  final _searchController = TextEditingController();
  final _apiService = getIt<MangaApiService>();

  bool _isLoadingSearch = false;
  List<Map<String, dynamic>> _searchResults = [];
  String? _error;

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoadingSearch = true;
      _error = null;
      _searchResults = [];
    });

    try {
      final results = await _apiService.searchScrapSource(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoadingSearch = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoadingSearch = false;
        });
      }
    }
  }

  Future<void> _scrapManga(String mangaUrl) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      await _apiService.scrapManga(mangaUrl, false);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        widget.onScrapped();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scraping added to queue!')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to scrap: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 720),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Scrap Source',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Query',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoadingSearch ? null : _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: _isLoadingSearch
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.red.withOpacity(0.1),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Expanded(
              child: _searchResults.isEmpty && !_isLoadingSearch
                  ? const Center(
                      child: Text(
                        'No results yet. Enter a query and search.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return _buildResultCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    final title = item['title'] as String? ?? 'Unknown';
    final type = item['type'] as String? ?? 'Manga';
    final detailUrl = item['detailUrl'] as String? ?? '';
    final thumbnail = item['thumbnail'] as String? ?? '';
    final latestChapter = item['latestChapterNumber']?.toString() ?? '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Thumbnail
          if (thumbnail.isNotEmpty)
            Image.network(
              thumbnail,
              width: 84,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 84,
                height: 120,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white54),
              ),
            )
          else
            Container(
              width: 84,
              height: 120,
              color: Colors.grey[800],
              child: const Icon(Icons.image, color: Colors.white54),
            ),

          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ch. $latestChapter',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: detailUrl.isEmpty
                  ? null
                  : () => _scrapManga(detailUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('SCRAP'),
            ),
          ),
        ],
      ),
    );
  }
}
