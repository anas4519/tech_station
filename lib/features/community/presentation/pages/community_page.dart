import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon ──
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primaryLight.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_rounded,
                    size: 48,
                    color: isDark ? AppColors.accentLight : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                Text('Community', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),

                Text(
                  'Coming Soon',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.accentLight : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Share your experiences, discuss devices,\nand connect with fellow tech enthusiasts.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ── Feature Preview Cards ──
                _buildFeaturePreview(
                  context,
                  icon: Icons.rate_review_rounded,
                  title: 'User Reviews',
                  description: 'Share your honest device reviews',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildFeaturePreview(
                  context,
                  icon: Icons.forum_rounded,
                  title: 'Discussions',
                  description: 'Ask questions and help others',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildFeaturePreview(
                  context,
                  icon: Icons.emoji_events_rounded,
                  title: 'Top Contributors',
                  description: 'Get recognized for your contributions',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePreview(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isDark ? AppColors.accentLight : AppColors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
