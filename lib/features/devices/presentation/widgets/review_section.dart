import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ReviewSection extends StatelessWidget {
  final String? reviewSummary;
  final List<String> pros;
  final List<String> cons;

  const ReviewSection({
    super.key,
    this.reviewSummary,
    this.pros = const [],
    this.cons = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (reviewSummary == null && pros.isEmpty && cons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Review not available yet.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reviewSummary != null) ...[
          Text(
            reviewSummary!,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 24),
        ],
        if (pros.isNotEmpty) ...[
          _buildProConHeader(
            context,
            icon: Icons.thumb_up_rounded,
            label: 'Pros',
            color: AppColors.success,
          ),
          const SizedBox(height: 8),
          ...pros.map(
            (pro) => _buildProConItem(
              context,
              text: pro,
              color: AppColors.success,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (cons.isNotEmpty) ...[
          _buildProConHeader(
            context,
            icon: Icons.thumb_down_rounded,
            label: 'Cons',
            color: AppColors.error,
          ),
          const SizedBox(height: 8),
          ...cons.map(
            (con) => _buildProConItem(
              context,
              text: con,
              color: AppColors.error,
              isDark: isDark,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProConHeader(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildProConItem(
    BuildContext context, {
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
