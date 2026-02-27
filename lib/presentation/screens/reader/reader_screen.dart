import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/reader_content.dart';
import '../../../data/services/manga_api_service.dart';

class ReaderScreen extends StatefulWidget {
  final ReaderContent content;

  const ReaderScreen({super.key, required this.content});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final MangaApiService _apiService = getIt<MangaApiService>();
  bool _showUI = true;
  bool _isLoading = false;
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _contentKey = GlobalKey();

  // Local state to allow chapter switching
  late List<String> _pageUrls;
  late String _chapterTitle;
  late double _currentChapterNumber;

  double _progress = 0.0;
  int _currentPage = 1;
  double _totalHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _pageUrls = widget.content.pageUrls;
    _chapterTitle = widget.content.chapterTitle;
    _currentChapterNumber = widget.content.currentChapterNumber;

    _transformationController.addListener(_onTransformationChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTotalHeight());
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _updateTotalHeight() {
    if (!mounted) return;
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.size.height > 0) {
      setState(() {
        _totalHeight = box.size.height;
      });
    }
  }

  void _onTransformationChanged() {
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final newHeight = box.size.height;
      if (newHeight != _totalHeight && newHeight > 0) {
        _totalHeight = newHeight;
      }
    }

    if (_totalHeight <= 0) return;

    final translation = _transformationController.value.getTranslation();
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final screenHeight = MediaQuery.of(context).size.height;

    final double scrollY = -translation.y;
    final double totalScaledHeight = _totalHeight * scale;
    final double maxScroll = totalScaledHeight - screenHeight;

    if (maxScroll > 0) {
      final newProgress = (scrollY / maxScroll).clamp(0.0, 1.0);
      final newPage = ((newProgress * (_pageUrls.length - 1)).round() + 1);

      if ((newProgress - _progress).abs() > 0.001 || newPage != _currentPage) {
        setState(() {
          _progress = newProgress;
          _currentPage = newPage;
        });
      }
    }
  }

  Future<void> _changeChapter(bool next) async {
    final chapters = widget.content.allChapters;
    // Chapters are usually sorted DESC (latest first)
    final currentIndex = chapters.indexWhere(
      (c) => c.chapterNumber == _currentChapterNumber,
    );

    int targetIndex;
    if (next) {
      // If DESC, next is lower index (e.g. current is chapter 5 at index 10, next is chapter 6 at index 9)
      targetIndex = currentIndex - 1;
    } else {
      targetIndex = currentIndex + 1;
    }

    if (targetIndex < 0 || targetIndex >= chapters.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            next ? 'This is the latest chapter' : 'This is the first chapter',
          ),
        ),
      );
      return;
    }

    final targetChapter = chapters[targetIndex];

    setState(() => _isLoading = true);

    try {
      final pages = await _apiService.getChapterPages(
        widget.content.mangaId,
        targetChapter.chapterNumber,
      );

      setState(() {
        _pageUrls = pages
            .map(
              (p) => _apiService.getLocalImageUrl(
                p['localImageUrl'] as String?,
                p['imageUrl'] as String?,
              ),
            )
            .toList();
        _chapterTitle = targetChapter.title;
        _currentChapterNumber = targetChapter.chapterNumber;
        _progress = 0.0;
        _currentPage = 1;
        _isLoading = false;
        // Reset scroll position
        _transformationController.value = Matrix4.identity();
      });

      // Re-measure height
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateTotalHeight());
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load chapter: $e')));
      }
    }
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _progress = value;
      final scale = _transformationController.value.getMaxScaleOnAxis();
      final screenHeight = MediaQuery.of(context).size.height;
      final maxScroll = (_totalHeight * scale) - screenHeight;

      if (maxScroll > 0) {
        final targetY = -value * maxScroll;
        final currentX = _transformationController.value.getTranslation().x;

        _transformationController.value = Matrix4.identity()
          ..translate(currentX, targetY)
          ..scale(scale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Content Area
          GestureDetector(
            onTap: _toggleUI,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 5.0,
              constrained: false,
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  key: _contentKey,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    else
                      ..._pageUrls.map((url) {
                        return Image.network(
                          url,
                          fit: BoxFit.fitWidth,
                          width: screenWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 600,
                              width: screenWidth,
                              color: Colors.black,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    const SizedBox(height: 250),
                  ],
                ),
              ),
            ),
          ),

          // Top Header
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showUI ? 0 : -150,
            left: 0,
            right: 0,
            child: _buildFloatingTopUI(),
          ),

          // Bottom Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showUI ? 20 : -350,
            left: 20,
            right: 20,
            child: _buildFloatingBottomUI(),
          ),

          // Mini Progress Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showUI ? 0 : 1,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTopUI() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildGlassIconButton(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.content.mangaTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _chapterTitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildGlassIconButton(Icons.bookmark_outline, () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomUI() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 45, 45, 45).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slider Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () => _changeChapter(false),
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: Colors.white10,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                      ),
                      child: Slider(
                        value: _progress,
                        onChanged: _onSliderChanged,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () => _changeChapter(true),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              // Info Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAGE $_currentPage OF ${_pageUrls.length}  •  ${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Colors.white60,
                          size: 16,
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.auto_awesome_motion_rounded,
                          color: Colors.white60,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
