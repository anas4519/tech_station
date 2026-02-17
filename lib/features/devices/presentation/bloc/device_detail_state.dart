import 'package:equatable/equatable.dart';

import '../../domain/entities/device_entity.dart';

abstract class DeviceDetailState extends Equatable {
  const DeviceDetailState();
  @override
  List<Object?> get props => [];
}

class DeviceDetailInitial extends DeviceDetailState {}

class DeviceDetailLoading extends DeviceDetailState {}

class DeviceDetailLoaded extends DeviceDetailState {
  final DeviceEntity device;
  const DeviceDetailLoaded(this.device);
  @override
  List<Object?> get props => [device];
}

class DeviceDetailError extends DeviceDetailState {
  final String message;
  const DeviceDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
