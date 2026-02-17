import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_device_by_id.dart';
import 'device_detail_event.dart';
import 'device_detail_state.dart';

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  final GetDeviceById getDeviceById;

  DeviceDetailBloc({required this.getDeviceById})
    : super(DeviceDetailInitial()) {
    on<DeviceDetailFetch>(_onFetch);
  }

  Future<void> _onFetch(
    DeviceDetailFetch event,
    Emitter<DeviceDetailState> emit,
  ) async {
    emit(DeviceDetailLoading());
    final result = await getDeviceById(event.deviceId);
    result.fold(
      (failure) => emit(DeviceDetailError(failure.message)),
      (device) => emit(DeviceDetailLoaded(device)),
    );
  }
}
