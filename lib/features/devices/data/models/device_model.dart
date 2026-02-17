import '../../domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.category,
    super.imageUrl,
    super.imageUrls,
    super.releaseDate,
    super.price,
    super.shortDescription,
    super.processor,
    super.ram,
    super.storage,
    super.display,
    super.displaySize,
    super.displayResolution,
    super.refreshRate,
    super.battery,
    super.chargingSpeed,
    super.os,
    super.rearCamera,
    super.frontCamera,
    super.connectivity,
    super.weight,
    super.dimensions,
    super.waterResistance,
    super.biometrics,
    super.overallScore,
    super.performanceScore,
    super.cameraScore,
    super.batteryScore,
    super.displayScore,
    super.valueScore,
    super.cameraSamples,
    super.reviewSummary,
    super.pros,
    super.cons,
    super.createdAt,
    super.updatedAt,
    super.isFeatured,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String? ?? 'Other',
      imageUrl: json['image_url'] as String?,
      imageUrls: _parseStringList(json['image_urls']),
      releaseDate: json['release_date'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      shortDescription: json['short_description'] as String?,
      processor: json['processor'] as String?,
      ram: json['ram'] as String?,
      storage: json['storage'] as String?,
      display: json['display'] as String?,
      displaySize: json['display_size'] as String?,
      displayResolution: json['display_resolution'] as String?,
      refreshRate: json['refresh_rate'] as String?,
      battery: json['battery'] as String?,
      chargingSpeed: json['charging_speed'] as String?,
      os: json['os'] as String?,
      rearCamera: json['rear_camera'] as String?,
      frontCamera: json['front_camera'] as String?,
      connectivity: json['connectivity'] as String?,
      weight: json['weight'] as String?,
      dimensions: json['dimensions'] as String?,
      waterResistance: json['water_resistance'] as String?,
      biometrics: json['biometrics'] as String?,
      overallScore: (json['overall_score'] as num?)?.toDouble() ?? 0,
      performanceScore: (json['performance_score'] as num?)?.toDouble() ?? 0,
      cameraScore: (json['camera_score'] as num?)?.toDouble() ?? 0,
      batteryScore: (json['battery_score'] as num?)?.toDouble() ?? 0,
      displayScore: (json['display_score'] as num?)?.toDouble() ?? 0,
      valueScore: (json['value_score'] as num?)?.toDouble() ?? 0,
      cameraSamples: _parseStringList(json['camera_samples']),
      reviewSummary: json['review_summary'] as String?,
      pros: _parseStringList(json['pros']),
      cons: _parseStringList(json['cons']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'release_date': releaseDate,
      'price': price,
      'short_description': shortDescription,
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'display': display,
      'display_size': displaySize,
      'display_resolution': displayResolution,
      'refresh_rate': refreshRate,
      'battery': battery,
      'charging_speed': chargingSpeed,
      'os': os,
      'rear_camera': rearCamera,
      'front_camera': frontCamera,
      'connectivity': connectivity,
      'weight': weight,
      'dimensions': dimensions,
      'water_resistance': waterResistance,
      'biometrics': biometrics,
      'overall_score': overallScore,
      'performance_score': performanceScore,
      'camera_score': cameraScore,
      'battery_score': batteryScore,
      'display_score': displayScore,
      'value_score': valueScore,
      'camera_samples': cameraSamples,
      'review_summary': reviewSummary,
      'pros': pros,
      'cons': cons,
      'is_featured': isFeatured,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
