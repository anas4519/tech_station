import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ScoreBadge extends StatelessWidget {
  final String label;
  final double score;
  final double size;

  const ScoreBadge({
    super.key,
    required this.label,
    required this.score,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = AppColors.scoreColor(score);

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: score / 10,
                  strokeWidth: 4,
                  backgroundColor: isDark
                      ? AppColors.grey800
                      : AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
