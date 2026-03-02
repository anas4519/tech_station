import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  /// Fetch paginated comments for a device, optionally filtered by [types] and sorted.
  Future<Either<Failure, List<CommentEntity>>> getComments({
    required String deviceId,
    List<String> types,
    String sortBy,
    int page,
    int limit,
  });

  /// Add a new comment (or reply if parentId is set).
  Future<Either<Failure, CommentEntity>> addComment({
    required String deviceId,
    required String type,
    required String body,
    String? parentId,
  });

  /// Toggle the "Helpful" vote on a comment (add if not voted, remove if already voted).
  Future<Either<Failure, CommentEntity>> toggleVote(String commentId);

  /// Mark a question as answered and set the best answer.
  Future<Either<Failure, void>> markAsAnswered({
    required String commentId,
    required String bestAnswerId,
  });

  /// Delete own comment.
  Future<Either<Failure, void>> deleteComment(String commentId);
}
