import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/device_entity.dart';
import '../bloc/device_detail_bloc.dart';
import '../bloc/device_detail_event.dart';
import '../bloc/device_detail_state.dart';
import '../widgets/score_badge.dart';
import '../widgets/spec_table.dart';
import '../widgets/camera_samples_gallery.dart';
import '../widgets/affiliate_links_section.dart';
import '../widgets/device_color_map.dart';
import '../../../comments/presentation/widgets/comments_section.dart';
import '../../../comments/presentation/bloc/comments_bloc.dart';
import '../../../comments/presentation/bloc/comments_event.dart';

class DeviceDetailPage extends StatefulWidget {
  final String deviceId;

  const DeviceDetailPage({super.key, required this.deviceId});

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _physicalDeviceModel = '';
  bool _isUploading = false;
  List<String>? _updatedSamples;
  int _currentImagePage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<DeviceDetailBloc>().add(DeviceDetailFetch(widget.deviceId));
    _detectPhysicalDevice();
  }

  Future<void> _detectPhysicalDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    String model = '';
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      model = info.model; // e.g. "Pixel 8 Pro"
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      model = info.name; // e.g. "Anas's iPhone 15 Pro"
      // Also try utsname.machine for exact model
      final machine = info.utsname.machine; // e.g. "iPhone16,2"
      // Combine both for matching
      model = '$model $machine';
    }
    if (mounted) {
      setState(() => _physicalDeviceModel = model.toLowerCase());
    }
  }

  bool _isCurrentDevice(DeviceEntity device) {
    if (_physicalDeviceModel.isEmpty ||
        device.deviceModel == null ||
        device.deviceModel!.isEmpty) {
      return false;
    }
    final model = device.deviceModel!.toLowerCase();
    // Exact or substring match against the physical device model string
    return _physicalDeviceModel.contains(model) ||
        model.contains(_physicalDeviceModel);
  }

  Future<void> _onCaptureSample(String deviceId) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxWidth: 4096,
    );
    if (photo == null || !mounted) return;

    context.read<DeviceDetailBloc>().add(
      DeviceDetailUploadCameraSample(deviceId: deviceId, filePath: photo.path),
    );
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
      body: BlocConsumer<DeviceDetailBloc, DeviceDetailState>(
        listener: (context, state) {
          if (state is DeviceDetailCameraSampleUploading) {
            setState(() => _isUploading = true);
          } else if (state is DeviceDetailCameraSampleUploaded) {
            setState(() {
              _isUploading = false;
              _updatedSamples = state.updatedSamples;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Camera sample uploaded successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is DeviceDetailError && _isUploading) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload failed: ${state.message}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is DeviceDetailLoading ||
            current is DeviceDetailLoaded ||
            (current is DeviceDetailError && previous is! DeviceDetailLoaded),
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
            background: _buildImageCarousel(device, isDark),
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

                // ── Available Colors ──
                if (device.availableColors.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: device.availableColors.map((colorName) {
                      final color = getDeviceColor(colorName);
                      final isLight =
                          ThemeData.estimateBrightnessForColor(color) ==
                          Brightness.light;
                      return Tooltip(
                        message: colorName,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isLight
                                  ? Colors.grey.shade400
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

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
              Tab(text: 'Community'),
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
                _buildCommunityTab(device),
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
          // ── Affiliate Links ──
          AffiliateLinksSection(links: device.affiliateLinks),
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
    final samples = _updatedSamples ?? device.cameraSamples;
    final isCurrent = _isCurrentDevice(device);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: CameraSamplesGallery(
        samples: samples,
        isCurrentDevice: isCurrent,
        isUploading: _isUploading,
        onCaptureSample: () => _onCaptureSample(device.id),
      ),
    );
  }

  Widget _buildCommunityTab(DeviceEntity device) {
    // Trigger initial fetch of comments
    context.read<CommentsBloc>().add(CommentsFetch(device.id));
    return CommentsSection(deviceId: device.id);
  }

  Widget _buildImageCarousel(DeviceEntity device, bool isDark) {
    // Combine main image + additional images
    final allImages = <String>[
      if (device.imageUrl != null) device.imageUrl!,
      ...device.imageUrls,
    ];

    if (allImages.isEmpty) {
      return Container(
        color: isDark ? AppColors.darkElevated : AppColors.grey100,
        child: Icon(
          Icons.smartphone_rounded,
          size: 80,
          color: isDark ? AppColors.grey600 : AppColors.grey400,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Image PageView ──
        PageView.builder(
          itemCount: allImages.length,
          onPageChanged: (index) {
            if (mounted) setState(() => _currentImagePage = index);
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openFullScreenImage(context, allImages, index),
              child: CachedNetworkImage(
                imageUrl: allImages[index],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: isDark ? AppColors.darkElevated : AppColors.grey100,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: isDark ? AppColors.darkElevated : AppColors.grey100,
                  child: const Icon(Icons.broken_image_rounded, size: 60),
                ),
              ),
            );
          },
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
                  (isDark ? AppColors.darkBg : AppColors.lightBg).withValues(
                    alpha: 0.9,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Dot indicators ──
        if (allImages.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(allImages.length, (i) {
                final isActive = i == _currentImagePage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isActive
                        ? (isDark ? AppColors.accentLight : AppColors.primary)
                        : (isDark ? AppColors.grey600 : AppColors.grey400),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  void _openFullScreenImage(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullScreenImageViewer(
            images: images,
            initialIndex: initialIndex,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _controller;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Swipeable images with zoom ──
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white54,
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image_rounded,
                      size: 60,
                      color: Colors.white38,
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Close button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // ── Page counter ──
          if (widget.images.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentPage + 1} / ${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // ── Dot indicators ──
          if (widget.images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isActive ? Colors.white : Colors.white38,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
