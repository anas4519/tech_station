import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';

class AffiliateLinksSection extends StatelessWidget {
  final List<Map<String, String>> links;

  const AffiliateLinksSection({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Icon(
              Icons.shopping_bag_rounded,
              size: 20,
              color: isDark ? AppColors.accentLight : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text('Where to Buy', style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 14),
        ...links.map(
          (link) => _AffiliateLinkCard(
            name: link['name'] ?? '',
            url: link['url'] ?? '',
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _AffiliateLinkCard extends StatelessWidget {
  final String name;
  final String url;
  final bool isDark;

  const _AffiliateLinkCard({
    required this.name,
    required this.url,
    required this.isDark,
  });

  Future<void> _openLink() async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isDark ? AppColors.darkElevated : AppColors.grey100,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _openLink,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Retailer icon container ──
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.accentLight.withValues(alpha: 0.2),
                            ]
                          : [
                              AppColors.primarySurface,
                              AppColors.primary.withValues(alpha: 0.1),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 20,
                    color: isDark ? AppColors.accentLight : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                // ── Retailer name ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to view deal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.grey500 : AppColors.grey600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Arrow icon ──
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: isDark ? AppColors.accentLight : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
