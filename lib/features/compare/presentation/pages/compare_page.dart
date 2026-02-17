import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compare',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Compare devices side by side',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: Row(
                  children: [
                    // ── Device 1 Slot ──
                    Expanded(
                      child: _buildDeviceSlot(context, isDark, 'Device 1'),
                    ),
                    const SizedBox(width: 16),

                    // ── VS Badge ──
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'VS',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ── Device 2 Slot ──
                    Expanded(
                      child: _buildDeviceSlot(context, isDark, 'Device 2'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Compare Button ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: null,
                  child: const Text('Compare Devices'),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Select two devices to compare their specs,\nscores, and features side by side.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceSlot(BuildContext context, bool isDark, String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Open device selector
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.grey800 : AppColors.grey200,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 48,
              color: isDark ? AppColors.grey600 : AppColors.grey400,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.grey500 : AppColors.grey600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.grey600 : AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
