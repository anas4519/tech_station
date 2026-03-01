import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../config/theme/app_colors.dart';

class CameraSamplesGallery extends StatelessWidget {
  final List<String> samples;
  final bool isCurrentDevice;
  final bool isUploading;
  final VoidCallback? onCaptureSample;

  const CameraSamplesGallery({
    super.key,
    required this.samples,
    this.isCurrentDevice = false,
    this.isUploading = false,
    this.onCaptureSample,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Upload Button ──
        if (isCurrentDevice) ...[
          _buildUploadSection(context, isDark),
          const SizedBox(height: 20),
        ],

        // ── Gallery ──
        if (samples.isEmpty && !isCurrentDevice)
          _buildEmptyState(isDark, theme)
        else if (samples.isEmpty && isCurrentDevice)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No samples yet. Be the first to add one!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          )
        else
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: samples.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullImage(context, samples[index], index),
                child: Hero(
                  tag: 'camera_sample_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: samples[index],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: index.isEven ? 200 : 260,
                        color: isDark
                            ? AppColors.darkElevated
                            : AppColors.grey100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 180,
                        color: isDark
                            ? AppColors.darkElevated
                            : AppColors.grey100,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildUploadSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accentLight.withValues(alpha: 0.1),
                ]
              : [
                  AppColors.primarySurface,
                  AppColors.primary.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.camera_alt_rounded,
            size: 32,
            color: isDark ? AppColors.accentLight : AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re using this device!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isDark ? AppColors.accentLight : AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Contribute a camera sample photo',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isUploading ? null : onCaptureSample,
              icon: isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add_a_photo_rounded, size: 20),
              label: Text(isUploading ? 'Uploading...' : 'Take a Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.primary : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: isDark ? AppColors.grey600 : AppColors.grey400,
            ),
            const SizedBox(height: 12),
            Text(
              'No camera samples available yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String url, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: 'camera_sample_$index',
              child: InteractiveViewer(
                child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
