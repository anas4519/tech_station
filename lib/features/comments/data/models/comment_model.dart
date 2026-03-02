import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.deviceId,
    required super.userId,
    required super.userName,
    super.userAvatarUrl,
    required super.type,
    required super.body,
    super.helpfulCount,
    super.isAnswered,
    super.bestAnswerId,
    super.parentId,
    super.isVotedByMe,
    required super.createdAt,
    super.replies,
  });

  factory CommentModel.fromJson(
    Map<String, dynamic> json, {
    bool votedByMe = false,
    List<CommentEntity> replies = const [],
  }) {
    return CommentModel(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String? ?? 'Anonymous',
      userAvatarUrl: json['user_avatar_url'] as String?,
      type: CommentType.fromDb(json['type'] as String),
      body: json['body'] as String,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      isAnswered: json['is_answered'] as bool? ?? false,
      bestAnswerId: json['best_answer_id'] as String?,
      parentId: json['parent_id'] as String?,
      isVotedByMe: votedByMe,
      createdAt: DateTime.parse(json['created_at'] as String),
      replies: replies,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'device_id': deviceId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'type': type.dbValue,
      'body': body,
      if (parentId != null) 'parent_id': parentId,
    };
  }
}
