import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'base_api_setting_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 32),

              _buildCategoryTitle('Settings'),
              _buildMenuItem(
                context,
                icon: Icons.api_outlined,
                title: 'Base API Setting',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BaseApiSettingScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.palette_outlined,
                title: 'Theme',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notification',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.language_outlined,
                title: 'Language',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildCategoryTitle('Data'),
              _buildMenuItem(
                context,
                icon: Icons.download_done_rounded,
                title: 'Downloaded Chapters',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.cleaning_services_outlined,
                title: 'Clear Cache',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.data_usage_outlined,
                title: 'Storage Usage',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildCategoryTitle('Stats'),
              _buildMenuItem(
                context,
                icon: Icons.bar_chart_outlined,
                title: 'Reading Statistics',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.access_time_outlined,
                title: 'Time Spent',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.menu_book_outlined,
                title: 'Chapters Read',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildCategoryTitle('Support'),
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.bug_report_outlined,
                title: 'Report Bug',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.library_add_outlined,
                title: 'Request Manga',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildCategoryTitle('About'),
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: 'v1.0.0',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.code,
                title: 'Open Source Licenses',
                onTap: () {},
              ),

              const SizedBox(height: 32),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'email@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.withOpacity(0.3)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'App Version v1.0.0',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
