import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    // Responsive padding and height
    final EdgeInsetsGeometry margin = isDesktop
        ? const EdgeInsets.only(left: 48, right: 48, bottom: 32)
        : isTablet
        ? const EdgeInsets.only(left: 36, right: 36, bottom: 28)
        : const EdgeInsets.only(left: 24, right: 24, bottom: 24);

    final double height = isDesktop
        ? 72
        : isTablet
        ? 68
        : 64;

    // Responsive border radius
    final double borderRadius = isDesktop
        ? 36
        : isTablet
        ? 34
        : 32;

    return Container(
      margin: margin,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white30).withValues(
                alpha: 0.7,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_rounded,
                  'Home',
                  isTablet || isDesktop,
                ),
                _buildNavItem(
                  1,
                  Icons.auto_stories_rounded,
                  'Library',
                  isTablet || isDesktop,
                ),
                _buildNavItem(
                  2,
                  Icons.explore_rounded,
                  'Discover',
                  isTablet || isDesktop,
                ),
                _buildNavItem(
                  3,
                  Icons.more_horiz_rounded,
                  'More',
                  isTablet || isDesktop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool showLabel) {
    final isActive = currentIndex == index;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: isActive ? 40 : 36,
                    height: isActive ? 40 : 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.secondary,
                        size: isActive ? 26 : 24,
                      ),
                    ),
                  ),
                  if (showLabel) ...[
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: isActive ? AppColors.primary : Colors.grey,
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      child: Text(label),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
