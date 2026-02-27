import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/manga_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
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
    final mangaList = [
      {
        'title': 'Solo Leveling',
        'ch': 179,
        'total': 200,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCVeb_Utgbq81e6ckYiFdwGTuY7y-GU96HC_X_IdMwi0qtcg74Yutu7BIbHoXOmGJnXEO8DFSs26PoQupRxlpJC-QA5gJIocM3QSdIw0_ps0-j4dY958MqmGuUSsFTQ0oxBIluOknb4PVLC3iaT3j18Gg1PHSkvT7_Cr6sUn7NcR9QpvPRPLg4USSkw2tmg7QAv6hg11Pxrq-L-82a3mWcG0LCmbPydskV23Hp_1dqb3JwWJ7FUF8XK-Dnq1lf66AzpI7UEfVLqIVT-',
        'progress': 0.85,
      },
      {
        'title': 'Berserk',
        'ch': 45,
        'total': 364,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAO-szwaQvjreXpRFFFGvt6p421cgslIA8bIrNEdHwLFLwDSCFC0z3_aOCGPu7ia1y4x5nCL_y4pL0PC0zUr3q1u-Re4gvaCuh-tPKEaY6ySQgbX9nTJdlE8KYIkFMuHtddTmyL4oS-aZA-ImA-814mK3HqhHod5gwpvb3GUp9TaDbw-dVXTlvjUMGIZfV_pTrAL5NjHVvuXHM_8gZx7pIytmnTmhKAnzKl85kVFiXwSuvC18Cd21amPtr1n-Dmm_7Y9JSU1bIoxFCU',
        'progress': 0.40,
      },
      {
        'title': 'One Piece',
        'ch': 1105,
        'total': 0,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD17JL11wR2YAVfkNZuodlEdCyTwDWNsPYQgqLTwtg0_LXpKypRoyaEA6qGBxpbpgaEYKiBBjplXQ9pfiCdDLag9nNHISdxy6YbruWLPVfF0SH80OYkIjwOa1lhhIa0K0qooaJOPh_SU8WmXeUDX4sq9U6e8vQ3h-1RJDtnvBRSnMSMO5obfYvsY2KA4C3iE8X8ysAFpKxjPzYNbWkNgpxF_ZhA7niQYKGJUxHQ6uydYXC33USmn3_BsKhXmqXRh_H-4xLiW5z9whpK',
        'progress': 1.0,
        'done': true,
      },
      {
        'title': 'Chainsaw Man',
        'ch': 12,
        'total': 150,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCMQQ8NXYWlmkR5LjAjEVs78MTe5_AJWAMEF64AR1zNI_VGqP1l2vIbKzIaT4zJFdeI02Lmvcvv69yPVa4t4hDBZL0RjYWyJ63cunkncXQiY6Ysfz4clN8yyskSQG11Gn-hnQq2vmBMVeEX7I7_vplcAQOSTl3aQc7_fFbkeQkzFdcFkn2wwOs7mxJdq-IqekRL9qtw7KNbOtEzAi36GVRflYbwI7J9XfpwnSfz6gQOmGopVQ3IoquVNrxnTn5k83YRk9hLyDsu_sUo',
        'progress': 0.15,
      },
      {
        'title': 'Oshi No Ko',
        'ch': 88,
        'total': 140,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC_Pp6YyVz2uy-IQzJ9qHm4TtDsPNjqgwjH9K20FcF3Y6GcVX-9rXa6Jhabrevgh9gZ5t0F5uKSrQ4B3o3y5ONCUieSyeXgCn7AJAw5L53IBNxpkr4xnjhAH4Nin4wzb4bmlSDhn6dYumtyE1eZftbhHQkjvANXWq209bLx-L0zUBMvkFUNFyBmB4eLagBakDWdCgPoGTI8373xs8Zoc3PZ1w6VKi91cFzJfvPkwvwhUzmZS1tdQ_vFXU2MvEUAHHxJTBqi2n6zU6ON',
        'progress': 0.6,
      },
      {
        'title': 'Jujutsu Kaisen',
        'ch': 245,
        'total': 260,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD4hj1Q71fG_bBer8DQ-HSfSl_Ke8bD1kgWaDsBop9w97M3yNPiVusgH87b4HUpDhYtEl7a9ErrwoIzVRBWCUu1yYxHNI5A93dGYUcK5eUrEiVfsf5bwqB8OlTivyXCFhRfi40_-_NT5W3H1m54ggGknDIEVSiTG3dtbgGZrT0Ab-HwOmMqC-P_jQZNXjfqAG5UosAhv3rZuWhIWF3GFBgG8NCl6RA3N0kF6xbw0xipXOasaqc8KqOswU160n0MPpCm0j5d4Znh9T9A',
        'progress': 0.92,
      },
      {
        'title': 'Blue Lock',
        'ch': 24,
        'total': 250,
        'img': null,
        'progress': 0.1,
      },
      {
        'title': 'Vagabond',
        'ch': 240,
        'total': 327,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDruYez1YrttXfZSVbEVpbCRwQ6rFOjeSfBYyvBP-ok0IMPRGZzAiF3HXT8j5vcTaRGFDiGkDmaWlYuqWetcparTIEVM4njFPTa8u_pbVMe73oE2DuyR5s7zB5gZMEP-bHkCoHlixzcMje2mnx04t9Q6CSIDG9b2MqUeMWpejf_rVbMhEYCvvlG19eT5OhAko5D6hX3hINW0_zE9Tlsz0bSXfkb87_wTSZjXQRPD0mmD0iYmrXnghv_2mFHO8qF8T1255mecW0MS5sC',
        'progress': 0.75,
      },
      {
        'title': 'Frieren',
        'ch': 40,
        'total': 120,
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAsV4gVQsWWbE1eB6TzxPzVgq9Oq8wCmyHqCRoPT19H3ejBUhUVklpIT8P7PqSroV0XW8K-Rp7PwZEVdZbfvw3NooW4eWIFEkAbhRPjBImLvXXw6-Pl5BdjwVaCJwuLTNcrYk8fiatyeApd-mCi10hZusewpwCsRgNCkR9OLwyF9vr8fqHEXHl6LZHHYMP3HIMnvcs6b4aQLKxVMsxiWbJ-OkF5sO2GbCv2czt8h3bLVfhh4QI9a7lEpCjg3xo6W5KmSx2aBpZ1WSXE',
        'progress': 0.33,
      },
    ];

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = mangaList[index];
        return MangaCard(
          title: item['title'] as String,
          imageUrl: item['img'] as String?,
          currentChapter: item['ch'] as int,
          totalChapters: item['total'] as int,
          progress: item['progress'] as double,
          isCompleted: item['done'] as bool? ?? false,
        );
      }, childCount: mangaList.length),
    );
  }
}
