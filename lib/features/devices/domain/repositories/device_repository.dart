import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<DeviceEntity>>> getAllDevices();
  Future<Either<Failure, DeviceEntity>> getDeviceById(String id);
  Future<Either<Failure, List<DeviceEntity>>> getDevicesByCategory(
    String category,
  );
  Future<Either<Failure, List<DeviceEntity>>> getDevicesByBrand(String brand);
  Future<Either<Failure, List<DeviceEntity>>> searchDevices(String query);
  Future<Either<Failure, List<DeviceEntity>>> getFeaturedDevices();
}
