import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/comment_entity.dart';
import '../bloc/comments_bloc.dart';
import '../bloc/comments_event.dart';
import '../bloc/comments_state.dart';
import 'add_comment_sheet.dart';
import 'comment_card.dart';

class CommentsSection extends StatelessWidget {
  final String deviceId;

  const CommentsSection({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state is CommentAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment posted!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is CommentsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is CommentsLoading ||
          current is CommentsLoaded ||
          (current is CommentsError && previous is! CommentsLoaded),
      builder: (context, state) {
        if (state is CommentsLoading) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: AppLoadingWidget(message: 'Loading comments...'),
          );
        }

        if (state is CommentsLoaded) {
          return _buildLoadedContent(
            context,
            state,
            isDark,
            theme,
            currentUserId,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    CommentsLoaded state,
    bool isDark,
    ThemeData theme,
    String? currentUserId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Filter chips ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: CommentFilter.values.map((filter) {
              final isActive = filter == state.activeFilter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter.label),
                  selected: isActive,
                  onSelected: (_) => context.read<CommentsBloc>().add(
                    CommentsFilterChanged(filter),
                  ),
                  selectedColor: isDark
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.primarySurface,
                  backgroundColor: isDark
                      ? AppColors.darkElevated
                      : AppColors.grey100,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? (isDark ? AppColors.accentLight : AppColors.primary)
                        : (isDark ? AppColors.grey400 : AppColors.grey600),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isActive
                          ? (isDark ? AppColors.accentLight : AppColors.primary)
                          : Colors.transparent,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // ── Sort + Add button row ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              // Sort dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkElevated : AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CommentSort>(
                    value: state.activeSort,
                    isDense: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.grey300 : AppColors.grey700,
                    ),
                    dropdownColor: isDark
                        ? AppColors.darkElevated
                        : Colors.white,
                    items: CommentSort.values
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.label)),
                        )
                        .toList(),
                    onChanged: (sort) {
                      if (sort != null) {
                        context.read<CommentsBloc>().add(
                          CommentsSortChanged(sort),
                        );
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              // Add comment button
              if (currentUserId != null)
                ElevatedButton.icon(
                  onPressed: () => _showAddComment(context, deviceId),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Comment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ── Comments list ──
        if (state.comments.isEmpty)
          _buildEmptyState(isDark, theme, currentUserId)
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
              itemCount: state.comments.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.comments.length) {
                  // Load more button
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: state.isLoadingMore
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : TextButton(
                              onPressed: () => context.read<CommentsBloc>().add(
                                const CommentsLoadMore(),
                              ),
                              child: Text(
                                'Load More',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.accentLight
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  );
                }

                final comment = state.comments[index];
                return Column(
                  children: [
                    // Top-level comment
                    CommentCard(
                      comment: comment,
                      currentUserId: currentUserId,
                      onVote: () => context.read<CommentsBloc>().add(
                        CommentsToggleVote(comment.id),
                      ),
                      onReply: () => _showAddComment(
                        context,
                        deviceId,
                        parentId: comment.id,
                      ),
                      onDelete: currentUserId == comment.userId
                          ? () => context.read<CommentsBloc>().add(
                              CommentsDelete(comment.id),
                            )
                          : null,
                    ),
                    // Replies
                    ...comment.replies.map((reply) {
                      final isBestAnswer = comment.bestAnswerId == reply.id;
                      return CommentCard(
                        comment: CommentEntity(
                          id: reply.id,
                          deviceId: reply.deviceId,
                          userId: reply.userId,
                          userName: reply.userName,
                          userAvatarUrl: reply.userAvatarUrl,
                          type: reply.type,
                          body: reply.body,
                          helpfulCount: reply.helpfulCount,
                          isAnswered: isBestAnswer,
                          bestAnswerId: reply.bestAnswerId,
                          parentId: reply.parentId,
                          isVotedByMe: reply.isVotedByMe,
                          createdAt: reply.createdAt,
                        ),
                        currentUserId: currentUserId,
                        isReply: true,
                        onVote: () => context.read<CommentsBloc>().add(
                          CommentsToggleVote(reply.id),
                        ),
                        onMarkAnswer:
                            comment.type == CommentType.question &&
                                currentUserId == comment.userId &&
                                !comment.isAnswered
                            ? (answerId) => context.read<CommentsBloc>().add(
                                CommentsMarkAnswered(
                                  questionId: comment.id,
                                  answerId: answerId,
                                ),
                              )
                            : null,
                        onDelete: currentUserId == reply.userId
                            ? () => context.read<CommentsBloc>().add(
                                CommentsDelete(reply.id),
                              )
                            : null,
                      );
                    }),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark, ThemeData theme, String? userId) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 40,
                  color: isDark ? AppColors.grey600 : AppColors.grey400,
                ),
                const SizedBox(height: 10),
                Text('No comments yet', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  userId != null
                      ? 'Be the first to share your experience!'
                      : 'Sign in to share your experience.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.grey500 : AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddComment(
    BuildContext context,
    String deviceId, {
    String? parentId,
  }) {
    final bloc = context.read<CommentsBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBg
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddCommentSheet(
        deviceId: deviceId,
        parentId: parentId,
        onSubmit: (type, body) {
          bloc.add(
            CommentsAdd(
              deviceId: deviceId,
              type: type,
              body: body,
              parentId: parentId,
            ),
          );
        },
      ),
    );
  }
}
