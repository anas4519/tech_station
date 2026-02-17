import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/device_entity.dart';

class DeviceCard extends StatelessWidget {
  final DeviceEntity device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/device/${device.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.grey800 : AppColors.grey200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: device.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: device.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: isDark
                                    ? AppColors.darkElevated
                                    : AppColors.grey100,
                                child: Icon(
                                  Icons.smartphone_rounded,
                                  size: 40,
                                  color: isDark
                                      ? AppColors.grey600
                                      : AppColors.grey400,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: isDark
                                    ? AppColors.darkElevated
                                    : AppColors.grey100,
                                child: Icon(
                                  Icons.smartphone_rounded,
                                  size: 40,
                                  color: isDark
                                      ? AppColors.grey600
                                      : AppColors.grey400,
                                ),
                              ),
                            )
                          : Container(
                              color: isDark
                                  ? AppColors.darkElevated
                                  : AppColors.grey100,
                              child: Center(
                                child: Icon(
                                  Icons.smartphone_rounded,
                                  size: 48,
                                  color: isDark
                                      ? AppColors.grey600
                                      : AppColors.grey400,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // ── Score Badge ──
                  if (device.overallScore > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scoreColor(device.overallScore),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          device.overallScore.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.accentLight
                            : AppColors.primary,
                        letterSpacing: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (device.price > 0)
                      Text(
                        '\$${device.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.accentLight
                              : AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
