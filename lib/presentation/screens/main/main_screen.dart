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

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(key: ValueKey('home')),
    const LibraryScreen(key: ValueKey('library')),
    const DiscoverScreen(key: ValueKey('discover')),
    const MoreScreen(key: ValueKey('more')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    children: <Widget>[
                      ...previousChildren,
                      ?currentChild,
                    ],
                  );
                },
            transitionBuilder: (Widget child, Animation<double> animation) {
              final isEntering = child.key == _screens[_currentIndex].key;
              final isMovingForward = _currentIndex > _previousIndex;

              Offset beginOffset;
              Offset endOffset;

              if (isEntering) {
                // The new screen entering
                beginOffset = isMovingForward
                    ? const Offset(1, 0)
                    : const Offset(-1, 0);
                endOffset = Offset.zero;
              } else {
                // The old screen exiting
                beginOffset = isMovingForward
                    ? const Offset(-1, 0)
                    : const Offset(1, 0);
                endOffset = Offset.zero;
              }

              // Use a CurvedAnimation for smoother motion
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              return SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: endOffset,
                ).animate(curvedAnimation),
                child: FadeTransition(opacity: curvedAnimation, child: child),
              );
            },
            child: _screens[_currentIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index != _currentIndex) {
                  setState(() {
                    _previousIndex = _currentIndex;
                    _currentIndex = index;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
