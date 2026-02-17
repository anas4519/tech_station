import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../config/supabase/supabase_config.dart';
import '../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getAllDevices();
  Future<DeviceModel> getDeviceById(String id);
  Future<List<DeviceModel>> getDevicesByCategory(String category);
  Future<List<DeviceModel>> getDevicesByBrand(String brand);
  Future<List<DeviceModel>> searchDevices(String query);
  Future<List<DeviceModel>> getFeaturedDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final SupabaseClient _supabase;

  DeviceRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  @override
  Future<List<DeviceModel>> getAllDevices() async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DeviceModel> getDeviceById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .eq('id', id)
          .single();

      return DeviceModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DeviceModel>> getDevicesByCategory(String category) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .eq('category', category)
          .order('overall_score', ascending: false);

      return (response as List)
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DeviceModel>> getDevicesByBrand(String brand) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .eq('brand', brand)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DeviceModel>> searchDevices(String query) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .or('name.ilike.%$query%,brand.ilike.%$query%')
          .order('overall_score', ascending: false);

      return (response as List)
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DeviceModel>> getFeaturedDevices() async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.devicesTable)
          .select()
          .eq('is_featured', true)
          .order('overall_score', ascending: false)
          .limit(10);

      return (response as List)
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
