import 'package:equatable/equatable.dart';

import '../../domain/entities/comment_entity.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentEntity> comments;
  final CommentFilter activeFilter;
  final CommentSort activeSort;
  final bool hasMore;
  final int page;
  final String deviceId;
  final bool isLoadingMore;

  const CommentsLoaded({
    required this.comments,
    this.activeFilter = CommentFilter.all,
    this.activeSort = CommentSort.newest,
    this.hasMore = true,
    this.page = 0,
    required this.deviceId,
    this.isLoadingMore = false,
  });

  CommentsLoaded copyWith({
    List<CommentEntity>? comments,
    CommentFilter? activeFilter,
    CommentSort? activeSort,
    bool? hasMore,
    int? page,
    String? deviceId,
    bool? isLoadingMore,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      activeFilter: activeFilter ?? this.activeFilter,
      activeSort: activeSort ?? this.activeSort,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      deviceId: deviceId ?? this.deviceId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    activeFilter,
    activeSort,
    hasMore,
    page,
    isLoadingMore,
  ];
}

class CommentsError extends CommentsState {
  final String message;
  const CommentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentAdding extends CommentsState {}

class CommentAdded extends CommentsState {}
