import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/services/manga_api_service.dart';
import '../../../../core/di/injection.dart';

class ScrapMangaDialog extends StatefulWidget {
  final VoidCallback onScrapped;

  const ScrapMangaDialog({super.key, required this.onScrapped});

  @override
  State<ScrapMangaDialog> createState() => _ScrapMangaDialogState();
}

class _ScrapMangaDialogState extends State<ScrapMangaDialog> {
  final _apiService = getIt<MangaApiService>();
  final _urlController = TextEditingController();
  bool _scrapChapters = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scrap New Manga'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlController,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              hintText: 'Manga URL',
              labelText: 'URL from source',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Text('Scrap Chapters?')),
              Switch(
                value: _scrapChapters,
                onChanged: _isLoading
                    ? null
                    : (val) {
                        setState(() => _scrapChapters = val);
                      },
              ),
            ],
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleScrap,
          child: const Text('Scrap'),
        ),
      ],
    );
  }

  Future<void> _handleScrap() async {
    if (_urlController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.scrapManga(_urlController.text, _scrapChapters);
      if (mounted) {
        Navigator.pop(context);
        widget.onScrapped();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
