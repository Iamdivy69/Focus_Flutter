import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../../usage/usage_providers.dart';
import 'app_limit_config_sheet.dart';

class AppPickerBottomSheet extends ConsumerStatefulWidget {
  const AppPickerBottomSheet({super.key});

  @override
  ConsumerState<AppPickerBottomSheet> createState() => _AppPickerBottomSheetState();
}

class _AppPickerBottomSheetState extends ConsumerState<AppPickerBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(installedAppsWithFilterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return CyberGlassCard(
          blurAmount: 16,
          backgroundOpacity: 0.1,
          borderRadius: 24,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Select Application',
                      style: CyberTypography.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search installed apps...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: CyberColors.electricBlue),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.toLowerCase();
                    });
                  },
                ),
              ),

              // App List
              Expanded(
                child: appsAsync.when(
                  data: (apps) {
                    final filteredApps = apps.where((app) {
                      final name = app['appName']?.toLowerCase() ?? '';
                      final pkg = app['packageName']?.toLowerCase() ?? '';
                      return name.contains(_searchQuery) || pkg.contains(_searchQuery);
                    }).toList();

                    if (filteredApps.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: filteredApps.length,
                      itemBuilder: (context, index) {
                        final app = filteredApps[index];
                        final name = app['appName'] ?? '';
                        final pkg = app['packageName'] ?? '';
                        const color = CyberColors.electricBlue;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: CyberTypography.titleSmall.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: CyberTypography.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            pkg,
                            style: CyberTypography.bodySmall.copyWith(
                              color: CyberColors.onSurfaceMuted,
                            ),
                          ),
                          onTap: () => _selectApp(context, name, pkg),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: CyberColors.electricBlue),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Failed to load apps: $err',
                        style: CyberTypography.bodyMedium.copyWith(color: CyberColors.scoreCritical),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: CyberColors.onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No Apps Found',
              style: CyberTypography.titleSmall.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search query or check permission settings.',
              style: CyberTypography.bodySmall.copyWith(color: CyberColors.onSurfaceMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _selectApp(BuildContext context, String appName, String packageName) {
    // Pop picker
    Navigator.pop(context);

    // Show config sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppLimitConfigSheet(
        appName: appName,
        packageName: packageName,
      ),
    );
  }
}
