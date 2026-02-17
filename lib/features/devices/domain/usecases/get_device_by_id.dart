import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetDeviceById extends UseCase<DeviceEntity, String> {
  final DeviceRepository repository;
  GetDeviceById(this.repository);

  @override
  Future<Either<Failure, DeviceEntity>> call(String params) {
    return repository.getDeviceById(params);
  }
}
