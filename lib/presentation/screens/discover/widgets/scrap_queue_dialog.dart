import 'package:flutter/material.dart';
import '../../../../data/models/queue_item.dart';
import '../../../../data/services/manga_api_service.dart';
import '../../../../core/di/injection.dart';

class ScrapQueueDialog extends StatelessWidget {
  const ScrapQueueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = getIt<MangaApiService>();

    return AlertDialog(
      title: const Text('Scraping Queue'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService.getScrapQueue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final items =
                snapshot.data?.map((e) => QueueItem.fromJson(e)).toList() ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('Queue is empty'));
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.mangaTitle),
                  subtitle: Text('Chapter ${item.chapterNumber}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.status == 'Processing'
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 10,
                        color: item.status == 'Processing'
                            ? Colors.orange
                            : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
