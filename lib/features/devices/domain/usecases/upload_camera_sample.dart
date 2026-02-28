import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

class UploadCameraSample
    extends UseCase<List<String>, UploadCameraSampleParams> {
  final DeviceRepository repository;
  UploadCameraSample(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(UploadCameraSampleParams params) {
    return repository.uploadCameraSample(params.deviceId, params.filePath);
  }
}

class UploadCameraSampleParams extends Equatable {
  final String deviceId;
  final String filePath;

  const UploadCameraSampleParams({
    required this.deviceId,
    required this.filePath,
  });

  @override
  List<Object?> get props => [deviceId, filePath];
}
