import 'package:equatable/equatable.dart';

abstract class DeviceListEvent extends Equatable {
  const DeviceListEvent();
  @override
  List<Object?> get props => [];
}

class DeviceListFetchAll extends DeviceListEvent {}

class DeviceListFetchByCategory extends DeviceListEvent {
  final String category;
  const DeviceListFetchByCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class DeviceListFetchByBrand extends DeviceListEvent {
  final String brand;
  const DeviceListFetchByBrand(this.brand);
  @override
  List<Object?> get props => [brand];
}

class DeviceListSearch extends DeviceListEvent {
  final String query;
  const DeviceListSearch(this.query);
  @override
  List<Object?> get props => [query];
}

class DeviceListFetchFeatured extends DeviceListEvent {}
