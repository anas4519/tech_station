import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/device_entity.dart';
import '../bloc/device_detail_bloc.dart';
import '../bloc/device_detail_event.dart';
import '../bloc/device_detail_state.dart';
import '../widgets/score_badge.dart';
import '../widgets/spec_table.dart';
import '../widgets/review_section.dart';
import '../widgets/camera_samples_gallery.dart';

class DeviceDetailPage extends StatefulWidget {
  final String deviceId;

  const DeviceDetailPage({super.key, required this.deviceId});

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<DeviceDetailBloc>().add(DeviceDetailFetch(widget.deviceId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
        builder: (context, state) {
          if (state is DeviceDetailLoading) {
            return const AppLoadingWidget(message: 'Loading device...');
          }

          if (state is DeviceDetailError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<DeviceDetailBloc>().add(
                DeviceDetailFetch(widget.deviceId),
              ),
            );
          }

          if (state is DeviceDetailLoaded) {
            return _buildContent(context, state.device, isDark);
          }

          return const AppLoadingWidget();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DeviceEntity device, bool isDark) {
    final theme = Theme.of(context);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          stretch: true,
          backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // ── Hero Image ──
                if (device.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: device.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: isDark
                          ? AppColors.darkElevated
                          : AppColors.grey100,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: isDark
                          ? AppColors.darkElevated
                          : AppColors.grey100,
                      child: const Icon(Icons.smartphone_rounded, size: 80),
                    ),
                  )
                else
                  Container(
                    color: isDark ? AppColors.darkElevated : AppColors.grey100,
                    child: Icon(
                      Icons.smartphone_rounded,
                      size: 80,
                      color: isDark ? AppColors.grey600 : AppColors.grey400,
                    ),
                  ),
                // ── Gradient bottom ──
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.darkBg : AppColors.lightBg)
                              .withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_rounded),
              onPressed: () {
                Share.share('Check out ${device.name} on Tech Station!');
              },
            ),
          ],
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Score ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.brand.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.accentLight : AppColors.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(device.name, style: theme.textTheme.displayMedium),
                if (device.shortDescription != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    device.shortDescription!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (device.price > 0)
                      Text(
                        '\$${device.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.accentLight
                              : AppColors.primary,
                        ),
                      ),
                    const Spacer(),
                    if (device.releaseDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkElevated
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          device.releaseDate!,
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                  ],
                ),

                // ── Score Badges ──
                if (device.overallScore > 0) ...[
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ScoreBadge(
                          label: 'Overall',
                          score: device.overallScore,
                        ),
                        const SizedBox(width: 16),
                        ScoreBadge(
                          label: 'Performance',
                          score: device.performanceScore,
                        ),
                        const SizedBox(width: 16),
                        ScoreBadge(label: 'Camera', score: device.cameraScore),
                        const SizedBox(width: 16),
                        ScoreBadge(
                          label: 'Battery',
                          score: device.batteryScore,
                        ),
                        const SizedBox(width: 16),
                        ScoreBadge(
                          label: 'Display',
                          score: device.displayScore,
                        ),
                        const SizedBox(width: 16),
                        ScoreBadge(label: 'Value', score: device.valueScore),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Tab Bar ──
          TabBar(
            controller: _tabController,
            labelColor: isDark ? AppColors.accentLight : AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.grey500
                : AppColors.grey600,
            indicatorColor: isDark ? AppColors.accentLight : AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Specs'),
              Tab(text: 'Camera'),
              Tab(text: 'Reviews'),
            ],
          ),

          // ── Tab Contents ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(device),
                _buildSpecsTab(device),
                _buildCameraTab(device),
                _buildReviewsTab(device),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(DeviceEntity device) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (device.shortDescription != null) ...[
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              device.shortDescription!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
          ],
          // Quick specs summary
          _buildQuickSpec(
            Icons.memory_rounded,
            'Processor',
            device.processor ?? 'N/A',
          ),
          _buildQuickSpec(
            Icons.storage_rounded,
            'RAM / Storage',
            '${device.ram ?? "N/A"} / ${device.storage ?? "N/A"}',
          ),
          _buildQuickSpec(
            Icons.battery_charging_full_rounded,
            'Battery',
            device.battery ?? 'N/A',
          ),
          _buildQuickSpec(
            Icons.camera_alt_rounded,
            'Camera',
            device.rearCamera ?? 'N/A',
          ),
          _buildQuickSpec(
            Icons.aspect_ratio_rounded,
            'Display',
            device.display ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSpec(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? AppColors.accentLight : AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsTab(DeviceEntity device) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: SpecTable(device: device),
    );
  }

  Widget _buildCameraTab(DeviceEntity device) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: CameraSamplesGallery(samples: device.cameraSamples),
    );
  }

  Widget _buildReviewsTab(DeviceEntity device) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ReviewSection(
        reviewSummary: device.reviewSummary,
        pros: device.pros,
        cons: device.cons,
      ),
    );
  }
}
