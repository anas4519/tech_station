import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

class GetCategories extends UseCase<List<String>, NoParams> {
  final DeviceRepository repository;
  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getCategories();
  }
}
