import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class AddCommentParams extends Equatable {
  final String deviceId;
  final String type;
  final String body;
  final String? parentId;

  const AddCommentParams({
    required this.deviceId,
    required this.type,
    required this.body,
    this.parentId,
  });

  @override
  List<Object?> get props => [deviceId, type, body, parentId];
}

class AddComment extends UseCase<CommentEntity, AddCommentParams> {
  final CommentRepository repository;
  AddComment(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(AddCommentParams params) {
    return repository.addComment(
      deviceId: params.deviceId,
      type: params.type,
      body: params.body,
      parentId: params.parentId,
    );
  }
}
