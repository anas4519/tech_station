import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetDevicesByCategory extends UseCase<List<DeviceEntity>, String> {
  final DeviceRepository repository;
  GetDevicesByCategory(this.repository);

  @override
  Future<Either<Failure, List<DeviceEntity>>> call(String params) {
    return repository.getDevicesByCategory(params);
  }
}
