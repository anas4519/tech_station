import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class MarkAsAnsweredParams extends Equatable {
  final String commentId;
  final String bestAnswerId;

  const MarkAsAnsweredParams({
    required this.commentId,
    required this.bestAnswerId,
  });

  @override
  List<Object?> get props => [commentId, bestAnswerId];
}

class MarkAsAnswered extends UseCase<void, MarkAsAnsweredParams> {
  final CommentRepository repository;
  MarkAsAnswered(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsAnsweredParams params) {
    return repository.markAsAnswered(
      commentId: params.commentId,
      bestAnswerId: params.bestAnswerId,
    );
  }
}
