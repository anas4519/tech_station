import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  // ── Basic Info ──
  final String id;
  final String name;
  final String brand;
  final String category;
  final String? imageUrl;
  final List<String> imageUrls;
  final String? releaseDate;
  final double price;
  final String? shortDescription;

  // ── Specs ──
  final String? processor;
  final String? ram;
  final String? storage;
  final String? display;
  final String? displaySize;
  final String? displayResolution;
  final String? refreshRate;
  final String? battery;
  final String? chargingSpeed;
  final String? os;
  final String? rearCamera;
  final String? frontCamera;
  final String? connectivity;
  final String? weight;
  final String? dimensions;
  final String? waterResistance;
  final String? biometrics;

  // ── Scores (out of 10) ──
  final double overallScore;
  final double performanceScore;
  final double cameraScore;
  final double batteryScore;
  final double displayScore;
  final double valueScore;

  // ── Camera samples ──
  final List<String> cameraSamples;

  // ── Review ──
  final String? reviewSummary;
  final List<String> pros;
  final List<String> cons;

  // ── Metadata ──
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isFeatured;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.imageUrl,
    this.imageUrls = const [],
    this.releaseDate,
    this.price = 0,
    this.shortDescription,
    this.processor,
    this.ram,
    this.storage,
    this.display,
    this.displaySize,
    this.displayResolution,
    this.refreshRate,
    this.battery,
    this.chargingSpeed,
    this.os,
    this.rearCamera,
    this.frontCamera,
    this.connectivity,
    this.weight,
    this.dimensions,
    this.waterResistance,
    this.biometrics,
    this.overallScore = 0,
    this.performanceScore = 0,
    this.cameraScore = 0,
    this.batteryScore = 0,
    this.displayScore = 0,
    this.valueScore = 0,
    this.cameraSamples = const [],
    this.reviewSummary,
    this.pros = const [],
    this.cons = const [],
    this.createdAt,
    this.updatedAt,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [id, name, brand, category, overallScore];
}
