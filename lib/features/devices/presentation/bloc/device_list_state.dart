import 'package:equatable/equatable.dart';

import '../../domain/entities/device_entity.dart';

abstract class DeviceListState extends Equatable {
  const DeviceListState();
  @override
  List<Object?> get props => [];
}

class DeviceListInitial extends DeviceListState {}

class DeviceListLoading extends DeviceListState {}

class DeviceListLoaded extends DeviceListState {
  final List<DeviceEntity> devices;
  final List<DeviceEntity> featuredDevices;

  const DeviceListLoaded({
    required this.devices,
    this.featuredDevices = const [],
  });

  @override
  List<Object?> get props => [devices, featuredDevices];
}

class DeviceListError extends DeviceListState {
  final String message;
  const DeviceListError(this.message);
  @override
  List<Object?> get props => [message];
}
