import 'package:equatable/equatable.dart';

import '../../domain/entities/comment_entity.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class CommentsFetch extends CommentsEvent {
  final String deviceId;
  const CommentsFetch(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class CommentsLoadMore extends CommentsEvent {
  const CommentsLoadMore();
}

class CommentsFilterChanged extends CommentsEvent {
  final CommentFilter filter;
  const CommentsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class CommentsSortChanged extends CommentsEvent {
  final CommentSort sort;
  const CommentsSortChanged(this.sort);

  @override
  List<Object?> get props => [sort];
}

class CommentsAdd extends CommentsEvent {
  final String deviceId;
  final String type;
  final String body;
  final String? parentId;

  const CommentsAdd({
    required this.deviceId,
    required this.type,
    required this.body,
    this.parentId,
  });

  @override
  List<Object?> get props => [deviceId, type, body, parentId];
}

class CommentsToggleVote extends CommentsEvent {
  final String commentId;
  const CommentsToggleVote(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

class CommentsMarkAnswered extends CommentsEvent {
  final String questionId;
  final String answerId;

  const CommentsMarkAnswered({
    required this.questionId,
    required this.answerId,
  });

  @override
  List<Object?> get props => [questionId, answerId];
}

class CommentsDelete extends CommentsEvent {
  final String commentId;
  const CommentsDelete(this.commentId);

  @override
  List<Object?> get props => [commentId];
}
