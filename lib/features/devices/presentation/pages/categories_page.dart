import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/device_list_bloc.dart';
import '../bloc/device_list_event.dart';
import '../bloc/device_list_state.dart';
import '../widgets/device_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _selectedBrand = 'All';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<DeviceListBloc>().add(DeviceListFetchAll());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Browse by brand or type',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Brand Chips ──
                    Text('Brand', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstants.phoneBrands.length,
                        itemBuilder: (context, index) {
                          final brand = AppConstants.phoneBrands[index];
                          final isSelected = brand == _selectedBrand;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(brand),
                              selected: isSelected,
                              onSelected: (_) => _onBrandSelected(brand),
                              selectedColor: isDark
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.primarySurface,
                              checkmarkColor: isDark
                                  ? AppColors.accentLight
                                  : AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Category Chips ──
                    Text('Category', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstants.deviceCategories.length,
                        itemBuilder: (context, index) {
                          final category = AppConstants.deviceCategories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (_) => _onCategorySelected(category),
                              selectedColor: isDark
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.primarySurface,
                              checkmarkColor: isDark
                                  ? AppColors.accentLight
                                  : AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Device Grid ──
            BlocBuilder<DeviceListBloc, DeviceListState>(
              builder: (context, state) {
                if (state is DeviceListLoading) {
                  return const SliverFillRemaining(
                    child: AppLoadingWidget(message: 'Loading...'),
                  );
                }

                if (state is DeviceListError) {
                  return SliverFillRemaining(
                    child: AppErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<DeviceListBloc>().add(
                        DeviceListFetchAll(),
                      ),
                    ),
                  );
                }

                if (state is DeviceListLoaded) {
                  final filtered = _filterDevices(state);
                  if (filtered.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: isDark
                                  ? AppColors.grey600
                                  : AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No devices found',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try a different filter',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childCount: filtered.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 240,
                          child: DeviceCard(device: filtered[index]),
                        );
                      },
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  List<dynamic> _filterDevices(DeviceListLoaded state) {
    var devices = state.devices;
    if (_selectedBrand != 'All') {
      devices = devices
          .where((d) => d.brand.toLowerCase() == _selectedBrand.toLowerCase())
          .toList();
    }
    if (_selectedCategory != 'All') {
      devices = devices
          .where(
            (d) => d.category.toLowerCase() == _selectedCategory.toLowerCase(),
          )
          .toList();
    }
    return devices;
  }

  void _onBrandSelected(String brand) {
    setState(() => _selectedBrand = brand);
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
  }
}
