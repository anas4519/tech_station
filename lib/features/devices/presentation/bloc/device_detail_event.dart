import 'package:equatable/equatable.dart';

abstract class DeviceDetailEvent extends Equatable {
  const DeviceDetailEvent();
  @override
  List<Object?> get props => [];
}

class DeviceDetailFetch extends DeviceDetailEvent {
  final String deviceId;
  const DeviceDetailFetch(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

class DeviceDetailUploadCameraSample extends DeviceDetailEvent {
  final String deviceId;
  final String filePath;
  const DeviceDetailUploadCameraSample({
    required this.deviceId,
    required this.filePath,
  });
  @override
  List<Object?> get props => [deviceId, filePath];
}
