import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/comment_entity.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;
  final VoidCallback onVote;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final void Function(String answerId)? onMarkAnswer;
  final bool isReply;
  final String? currentUserId;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onVote,
    this.onReply,
    this.onDelete,
    this.onMarkAnswer,
    this.isReply = false,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOwn = currentUserId != null && currentUserId == comment.userId;

    return Container(
      margin: EdgeInsets.only(bottom: 12, left: isReply ? 28 : 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? (isReply ? AppColors.darkBg : AppColors.darkElevated)
            : (isReply
                  ? AppColors.grey100.withValues(alpha: 0.5)
                  : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
          width: comment.isAnswered && comment.bestAnswerId != null && !isReply
              ? 0
              : 1,
        ),
        boxShadow: !isReply
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar + name + type badge ──
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: isDark
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.primarySurface,
                backgroundImage: comment.userAvatarUrl != null
                    ? NetworkImage(comment.userAvatarUrl!)
                    : null,
                child: comment.userAvatarUrl == null
                    ? Text(
                        comment.userName.isNotEmpty
                            ? comment.userName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.accentLight
                              : AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isDark ? AppColors.grey500 : AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(comment.type, isDark),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${comment.type.emoji} ${comment.type.label}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.grey800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Best Answer badge ──
          if (isReply && comment.parentId != null && _isBestAnswer(comment))
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '✅ Best Answer',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
            ),

          // ── Body ──
          Text(
            comment.body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),

          const SizedBox(height: 12),

          // ── Actions: helpful + reply + delete ──
          Row(
            children: [
              // Helpful button
              _ActionChip(
                icon: Icons.thumb_up_rounded,
                label: '${comment.helpfulCount}',
                isActive: comment.isVotedByMe,
                onTap: onVote,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              if (!isReply && onReply != null)
                _ActionChip(
                  icon: Icons.reply_rounded,
                  label: comment.replies.isNotEmpty
                      ? '${comment.replies.length}'
                      : 'Reply',
                  isActive: false,
                  onTap: onReply!,
                  isDark: isDark,
                ),
              const Spacer(),
              if (isOwn && onDelete != null)
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: isDark ? AppColors.grey500 : AppColors.grey400,
                  ),
                ),
              // Mark as answer (only for replies to questions)
              if (isReply && onMarkAnswer != null && !_isBestAnswer(comment))
                GestureDetector(
                  onTap: () => onMarkAnswer!(comment.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Mark Answer',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isBestAnswer(CommentEntity c) {
    // This would be checked against parent's bestAnswerId
    // For simplicity, we pass this info through
    return false; // handled in CommentsSection
  }

  Color _badgeColor(CommentType type, bool isDark) {
    final alpha = isDark ? 0.25 : 0.12;
    switch (type) {
      case CommentType.firstImpression:
        return Colors.orange.withValues(alpha: alpha);
      case CommentType.batteryReport:
        return Colors.green.withValues(alpha: alpha);
      case CommentType.heatingIssue:
        return Colors.red.withValues(alpha: alpha);
      case CommentType.bug:
        return Colors.red.withValues(alpha: alpha);
      case CommentType.cameraFeedback:
        return Colors.purple.withValues(alpha: alpha);
      case CommentType.performance:
        return Colors.blue.withValues(alpha: alpha);
      case CommentType.generalExperience:
        return Colors.teal.withValues(alpha: alpha);
      case CommentType.question:
        return Colors.amber.withValues(alpha: alpha);
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (isDark ? AppColors.accentLight : AppColors.primary)
        : (isDark ? AppColors.grey500 : AppColors.grey600);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
