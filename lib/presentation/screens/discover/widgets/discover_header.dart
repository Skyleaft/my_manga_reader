import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DiscoverHeader extends StatelessWidget {
  final bool isDark;
  final Function(String) onSearch;
  final VoidCallback onScrapManga;
  final VoidCallback onShowQueue;
  final VoidCallback onSearchScrapSource;
  final VoidCallback onFilter;
  final bool hasFilters;

  const DiscoverHeader({
    super.key,
    required this.isDark,
    required this.onSearch,
    required this.onScrapManga,
    required this.onShowQueue,
    required this.onSearchScrapSource,
    required this.onFilter,
    this.hasFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Discover',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onSearchScrapSource,
                    icon: const Icon(
                      Icons.search_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: onScrapManga,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: onShowQueue,
                    icon: const Icon(
                      Icons.notifications_none,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withOpacity(0.05)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onSubmitted: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search manga, manhwa, artists...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onFilter,
                  child: _buildFilterButton(
                    Icons.filter_list,
                    'Filters',
                    isActive: hasFilters,
                  ),
                ),
                _buildFilterOption('Sort: Popularity', Icons.sort),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondary : AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 18, color: Colors.black54),
        ],
      ),
    );
  }
}
