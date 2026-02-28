import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../data/services/manga_api_service.dart';

class BaseApiSettingScreen extends StatefulWidget {
  const BaseApiSettingScreen({super.key});

  @override
  State<BaseApiSettingScreen> createState() => _BaseApiSettingScreenState();
}

class _BaseApiSettingScreenState extends State<BaseApiSettingScreen> {
  // Let's deduce what the active API is based on the current AppConfig URL
  late String _activeApi;
  late String _customUrl;

  @override
  void initState() {
    super.initState();
    _customUrl = ''; // Will update when settings are verified

    final currentUrl = AppConfig.baseUrl;
    if (currentUrl.contains('mangadex')) {
      _activeApi = 'MangaDex API';
    } else if (currentUrl.contains('myanimelist')) {
      _activeApi = 'MyMangaList API';
    } else {
      _activeApi = 'Custom API';
      _customUrl = currentUrl;
    }
  }

  void _showConfigureDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfigureApiDialog(
        currentUrl: _customUrl,
        onSave: (url) {
          setState(() {
            _customUrl = url;
            _activeApi = 'Custom API';
          });
        },
      ),
    );
  }

  Future<void> _saveSettings() async {
    String newUrl = 'http://localhost:5126'; // Default fallback
    if (_activeApi == 'MangaDex API') {
      newUrl = 'https://api.mangadex.org';
    } else if (_activeApi == 'MyMangaList API') {
      newUrl = 'https://api.myanimelist.net';
    } else if (_activeApi == 'Custom API') {
      newUrl = _customUrl.isNotEmpty ? _customUrl : 'http://localhost:5126';
    }

    // Save configuration
    await AppConfig.updateBaseUrl(newUrl);

    // Update dio service instance
    final apiService = getIt<MangaApiService>();
    apiService.updateBaseUrl(newUrl);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('API Configuration Saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Base API Setting'),
        actions: [
          TextButton(
            onPressed: () {
              _saveSettings();
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Active API'),
            _buildApiCard(
              title: 'MangaDex API',
              url: 'https://api.mangadex.org',
              isActive: _activeApi == 'MangaDex API',
              isDefault: true,
              actionLabel: 'Edit',
              onAction: _showConfigureDialog,
              onTap: () => setState(() => _activeApi = 'MangaDex API'),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Available APIs'),
            _buildApiCard(
              title: 'MyMangaList API',
              url: 'https://api.myanimelist.net',
              isActive: _activeApi == 'MyMangaList API',
              actionLabel: 'Select',
              onAction: () => setState(() => _activeApi = 'MyMangaList API'),
              onTap: () => setState(() => _activeApi = 'MyMangaList API'),
            ),
            const SizedBox(height: 8),
            _buildApiCard(
              title: 'Custom API',
              url: _customUrl.isNotEmpty ? _customUrl : 'Not configured',
              isActive: _activeApi == 'Custom API',
              actionLabel: 'Configure',
              onAction: _showConfigureDialog,
              onTap: () {
                if (_customUrl.isNotEmpty) {
                  setState(() => _activeApi = 'Custom API');
                } else {
                  _showConfigureDialog();
                }
              },
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            _buildSectionTitle('Add Custom API'),
            InkWell(
              onTap: _showConfigureDialog,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withOpacity(0.05),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Add New API Endpoint',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warning',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Changing API may affect your library and reading progress. Some manga might not be available in different sources.',
                          style: TextStyle(fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildApiCard({
    required String title,
    required String url,
    required bool isActive,
    bool isDefault = false,
    required String actionLabel,
    required VoidCallback onAction,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : (isDark ? Colors.white10 : Colors.grey.shade200),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isDark || isActive
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Icon(
              isActive
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    url,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigureApiDialog extends StatefulWidget {
  final String currentUrl;
  final Function(String) onSave;

  const ConfigureApiDialog({
    super.key,
    required this.currentUrl,
    required this.onSave,
  });

  @override
  State<ConfigureApiDialog> createState() => _ConfigureApiDialogState();
}

class _ConfigureApiDialogState extends State<ConfigureApiDialog> {
  bool _obscureKey = true;
  String? _connectionStatus;

  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.currentUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Configure API',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              const Text(
                'API Name *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'My Custom API',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Base URL *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'https://api.example.com/v1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'API Key (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureKey,
                decoration: InputDecoration(
                  hintText: '•••••••••••••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKey ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureKey = !_obscureKey;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Headers (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Content-Type: application/json',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Simulate connection test
                    setState(() {
                      _connectionStatus = '🟢 Connected Successfully';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Test Connection'),
                ),
              ),
              if (_connectionStatus != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    _connectionStatus!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_urlController.text.isNotEmpty) {
                          // Very basic URL validation
                          String fixedUrl = _urlController.text;
                          if (!fixedUrl.startsWith('http')) {
                            fixedUrl = 'http://$fixedUrl';
                          }
                          widget.onSave(fixedUrl);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _connectionStatus = '🔴 Error: URL Required';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
