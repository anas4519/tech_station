import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments({
    required String deviceId,
    List<String> types = const [],
    String sortBy = 'created_at',
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final comments = await remoteDataSource.getComments(
        deviceId: deviceId,
        types: types,
        sortBy: sortBy,
        page: page,
        limit: limit,
      );
      return Right(comments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment({
    required String deviceId,
    required String type,
    required String body,
    String? parentId,
  }) async {
    try {
      final comment = await remoteDataSource.addComment(
        deviceId: deviceId,
        type: type,
        body: body,
        parentId: parentId,
      );
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> toggleVote(String commentId) async {
    try {
      final comment = await remoteDataSource.toggleVote(commentId);
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsAnswered({
    required String commentId,
    required String bestAnswerId,
  }) async {
    try {
      await remoteDataSource.markAsAnswered(
        commentId: commentId,
        bestAnswerId: bestAnswerId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
