import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/app_colors.dart';

class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: GNav(
              selectedIndex: navigationShell.currentIndex,
              onTabChange: (index) => _onTabChange(index),
              gap: 8,
              activeColor: isDark ? AppColors.accentLight : AppColors.primary,
              iconSize: 22,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBorderRadius: 14,
              color: isDark ? AppColors.grey600 : AppColors.grey500,
              tabBackgroundColor: isDark
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.primarySurface,
              textStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.accentLight : AppColors.primary,
              ),
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.category_rounded, text: 'Categories'),
                GButton(icon: Icons.compare_arrows_rounded, text: 'Compare'),
                GButton(icon: Icons.people_rounded, text: 'Community'),
                GButton(icon: Icons.person_rounded, text: 'Account'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabChange(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
