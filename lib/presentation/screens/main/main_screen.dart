import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../discover/discover_screen.dart';
import '../more/more_screen.dart';
import '../../../core/widgets/app_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late AnimationController _animationController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _fadeAnimation;

  final List<Widget> _screens = [
    const HomeScreen(key: ValueKey('home')),
    const LibraryScreen(key: ValueKey('library')),
    const DiscoverScreen(key: ValueKey('discover')),
    const MoreScreen(key: ValueKey('more')),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index != _currentIndex) {
      final isMovingForward = index > _currentIndex;

      // Set up slide animation
      _slideAnimation =
          Tween<Offset>(
            begin: isMovingForward ? const Offset(1, 0) : const Offset(-1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

      // Set up fade animation for the new screen
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _animationController.reset();
      _animationController.forward();

      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Previous screen (sliding out)
          if (_previousIndex != _currentIndex)
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: Offset.zero,
                    end: _currentIndex > _previousIndex
                        ? const Offset(-1, 0)
                        : const Offset(1, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
                    ),
                  ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
                  ),
                ),
                child: _screens[_previousIndex],
              ),
            ),

          // Current screen (sliding in)
          SlideTransition(
            position:
                _slideAnimation ??
                Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset.zero,
                ).animate(_animationController),
            child: FadeTransition(
              opacity:
                  _fadeAnimation ??
                  Tween<double>(
                    begin: 1.0,
                    end: 1.0,
                  ).animate(_animationController),
              child: _screens[_currentIndex],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(
              currentIndex: _currentIndex,
              onTap: _navigateTo,
            ),
          ),
        ],
      ),
    );
  }
}
