import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class ToggleVote extends UseCase<CommentEntity, String> {
  final CommentRepository repository;
  ToggleVote(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(String commentId) {
    return repository.toggleVote(commentId);
  }
}
