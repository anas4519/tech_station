import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetAllDevices extends UseCase<List<DeviceEntity>, NoParams> {
  final DeviceRepository repository;
  GetAllDevices(this.repository);

  @override
  Future<Either<Failure, List<DeviceEntity>>> call(NoParams params) {
    return repository.getAllDevices();
  }
}
