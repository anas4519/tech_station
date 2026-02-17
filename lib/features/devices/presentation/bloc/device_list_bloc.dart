import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_devices.dart';
import '../../domain/usecases/get_devices_by_category.dart';
import '../../domain/usecases/search_devices.dart';
import 'device_list_event.dart';
import 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  final GetAllDevices getAllDevices;
  final GetDevicesByCategory getDevicesByCategory;
  final SearchDevices searchDevices;

  DeviceListBloc({
    required this.getAllDevices,
    required this.getDevicesByCategory,
    required this.searchDevices,
  }) : super(DeviceListInitial()) {
    on<DeviceListFetchAll>(_onFetchAll);
    on<DeviceListFetchByCategory>(_onFetchByCategory);
    on<DeviceListSearch>(_onSearch);
  }

  Future<void> _onFetchAll(
    DeviceListFetchAll event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(DeviceListLoading());
    final result = await getAllDevices(NoParams());
    result.fold((failure) => emit(DeviceListError(failure.message)), (devices) {
      final featured = devices.where((d) => d.isFeatured).toList();
      emit(DeviceListLoaded(devices: devices, featuredDevices: featured));
    });
  }

  Future<void> _onFetchByCategory(
    DeviceListFetchByCategory event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(DeviceListLoading());
    final result = await getDevicesByCategory(event.category);
    result.fold(
      (failure) => emit(DeviceListError(failure.message)),
      (devices) => emit(DeviceListLoaded(devices: devices)),
    );
  }

  Future<void> _onSearch(
    DeviceListSearch event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(DeviceListLoading());
    final result = await searchDevices(event.query);
    result.fold(
      (failure) => emit(DeviceListError(failure.message)),
      (devices) => emit(DeviceListLoaded(devices: devices)),
    );
  }
}
