import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class DeleteComment extends UseCase<void, String> {
  final CommentRepository repository;
  DeleteComment(this.repository);

  @override
  Future<Either<Failure, void>> call(String commentId) {
    return repository.deleteComment(commentId);
  }
}
