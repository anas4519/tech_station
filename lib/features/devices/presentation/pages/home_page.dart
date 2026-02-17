import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/device_list_bloc.dart';
import '../bloc/device_list_event.dart';
import '../bloc/device_list_state.dart';
import '../widgets/device_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tech Station',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Discover your next device',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.devices_rounded,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Search Bar ──
                    GestureDetector(
                      onTap: () => _showSearch(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkElevated
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.grey800
                                : AppColors.grey200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: isDark
                                  ? AppColors.grey500
                                  : AppColors.grey400,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search devices...',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.grey600
                                    : AppColors.grey500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Content ──
            BlocBuilder<DeviceListBloc, DeviceListState>(
              builder: (context, state) {
                if (state is DeviceListLoading) {
                  return const SliverFillRemaining(
                    child: AppLoadingWidget(message: 'Loading devices...'),
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
                  if (state.devices.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.smartphone_rounded,
                              size: 64,
                              color: isDark
                                  ? AppColors.grey600
                                  : AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No devices yet',
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Device listings will appear here\nonce added from the admin panel.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Featured Devices ──
                      if (state.featuredDevices.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(context, 'Featured'),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.featuredDevices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: SizedBox(
                                  width: 170,
                                  child: DeviceCard(
                                    device: state.featuredDevices[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── All Devices ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildSectionHeader(
                          context,
                          'All Devices',
                          count: state.devices.length,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          itemCount: state.devices.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 240,
                              child: DeviceCard(device: state.devices[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  );
                }

                return const SliverFillRemaining(child: AppLoadingWidget());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {int? count}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accentLight
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _DeviceSearchDelegate(bloc: context.read<DeviceListBloc>()),
    );
  }
}

class _DeviceSearchDelegate extends SearchDelegate<String> {
  final DeviceListBloc bloc;

  _DeviceSearchDelegate({required this.bloc});

  @override
  String get searchFieldLabel => 'Search devices...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      bloc.add(DeviceListSearch(query));
    }
    return BlocBuilder<DeviceListBloc, DeviceListState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is DeviceListLoading) {
          return const AppLoadingWidget(message: 'Searching...');
        }
        if (state is DeviceListLoaded) {
          if (state.devices.isEmpty) {
            return Center(
              child: Text(
                'No results for "$query"',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              final device = state.devices[index];
              return ListTile(
                leading: const Icon(Icons.smartphone_rounded),
                title: Text(device.name),
                subtitle: Text(device.brand),
                onTap: () {
                  close(context, '');
                  context.push('/device/${device.id}');
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search for phones by name or brand'));
  }
}
