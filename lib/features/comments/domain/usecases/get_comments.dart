import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsParams extends Equatable {
  final String deviceId;
  final List<String> types;
  final String sortBy;
  final int page;
  final int limit;

  const GetCommentsParams({
    required this.deviceId,
    this.types = const [],
    this.sortBy = 'created_at',
    this.page = 0,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [deviceId, types, sortBy, page, limit];
}

class GetComments extends UseCase<List<CommentEntity>, GetCommentsParams> {
  final CommentRepository repository;
  GetComments(this.repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(GetCommentsParams params) {
    return repository.getComments(
      deviceId: params.deviceId,
      types: params.types,
      sortBy: params.sortBy,
      page: params.page,
      limit: params.limit,
    );
  }
}
