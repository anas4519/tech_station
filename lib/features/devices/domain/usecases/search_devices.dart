import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class SearchDevices extends UseCase<List<DeviceEntity>, String> {
  final DeviceRepository repository;
  SearchDevices(this.repository);

  @override
  Future<Either<Failure, List<DeviceEntity>>> call(String params) {
    return repository.searchDevices(params);
  }
}
