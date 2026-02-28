import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_device_by_id.dart';
import '../../domain/usecases/upload_camera_sample.dart';
import 'device_detail_event.dart';
import 'device_detail_state.dart';

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  final GetDeviceById getDeviceById;
  final UploadCameraSample uploadCameraSample;

  DeviceDetailBloc({
    required this.getDeviceById,
    required this.uploadCameraSample,
  }) : super(DeviceDetailInitial()) {
    on<DeviceDetailFetch>(_onFetch);
    on<DeviceDetailUploadCameraSample>(_onUploadCameraSample);
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

  Future<void> _onUploadCameraSample(
    DeviceDetailUploadCameraSample event,
    Emitter<DeviceDetailState> emit,
  ) async {
    emit(DeviceDetailCameraSampleUploading());
    final result = await uploadCameraSample(
      UploadCameraSampleParams(
        deviceId: event.deviceId,
        filePath: event.filePath,
      ),
    );
    result.fold(
      (failure) => emit(DeviceDetailError(failure.message)),
      (samples) => emit(DeviceDetailCameraSampleUploaded(samples)),
    );
  }
}
