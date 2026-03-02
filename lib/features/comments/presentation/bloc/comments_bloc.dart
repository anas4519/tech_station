import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/get_comments.dart';
import '../../domain/usecases/mark_as_answered.dart';
import '../../domain/usecases/toggle_vote.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetComments getComments;
  final AddComment addComment;
  final ToggleVote toggleVote;
  final MarkAsAnswered markAsAnswered;
  final DeleteComment deleteComment;

  static const int _pageSize = 20;

  CommentsBloc({
    required this.getComments,
    required this.addComment,
    required this.toggleVote,
    required this.markAsAnswered,
    required this.deleteComment,
  }) : super(CommentsInitial()) {
    on<CommentsFetch>(_onFetch);
    on<CommentsLoadMore>(_onLoadMore);
    on<CommentsFilterChanged>(_onFilterChanged);
    on<CommentsSortChanged>(_onSortChanged);
    on<CommentsAdd>(_onAdd);
    on<CommentsToggleVote>(_onToggleVote);
    on<CommentsMarkAnswered>(_onMarkAnswered);
    on<CommentsDelete>(_onDelete);
  }

  Future<void> _onFetch(
    CommentsFetch event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    final result = await getComments(
      GetCommentsParams(deviceId: event.deviceId, limit: _pageSize),
    );
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(
        CommentsLoaded(
          comments: comments,
          deviceId: event.deviceId,
          hasMore: comments.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    CommentsLoadMore event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await getComments(
      GetCommentsParams(
        deviceId: current.deviceId,
        types: current.activeFilter.dbValues,
        sortBy: current.activeSort.column,
        page: nextPage,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (newComments) => emit(
        current.copyWith(
          comments: [...current.comments, ...newComments],
          page: nextPage,
          hasMore: newComments.length >= _pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onFilterChanged(
    CommentsFilterChanged event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;

    emit(CommentsLoading());
    final result = await getComments(
      GetCommentsParams(
        deviceId: current.deviceId,
        types: event.filter.dbValues,
        sortBy: current.activeSort.column,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(
        CommentsLoaded(
          comments: comments,
          deviceId: current.deviceId,
          activeFilter: event.filter,
          activeSort: current.activeSort,
          hasMore: comments.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onSortChanged(
    CommentsSortChanged event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;

    emit(CommentsLoading());
    final result = await getComments(
      GetCommentsParams(
        deviceId: current.deviceId,
        types: current.activeFilter.dbValues,
        sortBy: event.sort.column,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) => emit(
        CommentsLoaded(
          comments: comments,
          deviceId: current.deviceId,
          activeFilter: current.activeFilter,
          activeSort: event.sort,
          hasMore: comments.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onAdd(CommentsAdd event, Emitter<CommentsState> emit) async {
    final prevState = state;
    emit(CommentAdding());

    final result = await addComment(
      AddCommentParams(
        deviceId: event.deviceId,
        type: event.type,
        body: event.body,
        parentId: event.parentId,
      ),
    );

    result.fold((failure) => emit(CommentsError(failure.message)), (comment) {
      emit(CommentAdded());
      // Re-fetch to get fresh list
      if (prevState is CommentsLoaded) {
        add(CommentsFetch(prevState.deviceId));
      } else {
        add(CommentsFetch(event.deviceId));
      }
    });
  }

  Future<void> _onToggleVote(
    CommentsToggleVote event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;

    final result = await toggleVote(event.commentId);
    result.fold(
      (_) {}, // silently fail
      (updated) {
        // Update the comment in the list
        final updatedComments = current.comments.map((c) {
          if (c.id == updated.id) return updated;
          // Check replies too
          final updatedReplies = c.replies.map((r) {
            if (r.id == updated.id) return updated;
            return r;
          }).toList();
          if (updatedReplies != c.replies) {
            return CommentEntity(
              id: c.id,
              deviceId: c.deviceId,
              userId: c.userId,
              userName: c.userName,
              userAvatarUrl: c.userAvatarUrl,
              type: c.type,
              body: c.body,
              helpfulCount: c.helpfulCount,
              isAnswered: c.isAnswered,
              bestAnswerId: c.bestAnswerId,
              parentId: c.parentId,
              isVotedByMe: c.isVotedByMe,
              createdAt: c.createdAt,
              replies: updatedReplies,
            );
          }
          return c;
        }).toList();
        emit(current.copyWith(comments: updatedComments));
      },
    );
  }

  Future<void> _onMarkAnswered(
    CommentsMarkAnswered event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;

    final result = await markAsAnswered(
      MarkAsAnsweredParams(
        commentId: event.questionId,
        bestAnswerId: event.answerId,
      ),
    );

    result.fold((_) {}, (_) => add(CommentsFetch(current.deviceId)));
  }

  Future<void> _onDelete(
    CommentsDelete event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final current = state as CommentsLoaded;

    final result = await deleteComment(event.commentId);
    result.fold((_) {}, (_) => add(CommentsFetch(current.deviceId)));
  }
}
