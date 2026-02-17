import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/device_entity.dart';

class SpecTable extends StatelessWidget {
  final DeviceEntity device;

  const SpecTable({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final specs = <MapEntry<String, String>>[
      if (device.processor != null) MapEntry('Processor', device.processor!),
      if (device.ram != null) MapEntry('RAM', device.ram!),
      if (device.storage != null) MapEntry('Storage', device.storage!),
      if (device.display != null) MapEntry('Display', device.display!),
      if (device.displaySize != null)
        MapEntry('Display Size', device.displaySize!),
      if (device.displayResolution != null)
        MapEntry('Resolution', device.displayResolution!),
      if (device.refreshRate != null)
        MapEntry('Refresh Rate', device.refreshRate!),
      if (device.battery != null) MapEntry('Battery', device.battery!),
      if (device.chargingSpeed != null)
        MapEntry('Charging', device.chargingSpeed!),
      if (device.os != null) MapEntry('OS', device.os!),
      if (device.rearCamera != null)
        MapEntry('Rear Camera', device.rearCamera!),
      if (device.frontCamera != null)
        MapEntry('Front Camera', device.frontCamera!),
      if (device.connectivity != null)
        MapEntry('Connectivity', device.connectivity!),
      if (device.weight != null) MapEntry('Weight', device.weight!),
      if (device.dimensions != null) MapEntry('Dimensions', device.dimensions!),
      if (device.waterResistance != null)
        MapEntry('Water Resistance', device.waterResistance!),
      if (device.biometrics != null) MapEntry('Biometrics', device.biometrics!),
    ];

    if (specs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Specs not available yet.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: specs.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: isDark ? AppColors.grey800 : AppColors.grey200,
      ),
      itemBuilder: (context, index) {
        final spec = specs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  spec.key,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.grey500 : AppColors.grey600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  spec.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
