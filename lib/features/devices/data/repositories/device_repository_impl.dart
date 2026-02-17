import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DeviceEntity>>> getAllDevices() async {
    try {
      final devices = await remoteDataSource.getAllDevices();
      return Right(devices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DeviceEntity>> getDeviceById(String id) async {
    try {
      final device = await remoteDataSource.getDeviceById(id);
      return Right(device);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevicesByCategory(
    String category,
  ) async {
    try {
      final devices = await remoteDataSource.getDevicesByCategory(category);
      return Right(devices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevicesByBrand(
    String brand,
  ) async {
    try {
      final devices = await remoteDataSource.getDevicesByBrand(brand);
      return Right(devices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DeviceEntity>>> searchDevices(
    String query,
  ) async {
    try {
      final devices = await remoteDataSource.searchDevices(query);
      return Right(devices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DeviceEntity>>> getFeaturedDevices() async {
    try {
      final devices = await remoteDataSource.getFeaturedDevices();
      return Right(devices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
