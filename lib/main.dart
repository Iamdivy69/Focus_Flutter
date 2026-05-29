import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/debug_navigator.dart';
import 'core/supabase_options.dart';
import 'core/background/usage_sync_service.dart';
import 'data/local/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase if keys are provided (allows local-only testing)
  if (SupabaseOptions.url.isNotEmpty && SupabaseOptions.anonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: SupabaseOptions.url,
        anonKey: SupabaseOptions.anonKey,
      );
    } catch (e) {
      debugPrint('Supabase init failed: $e');
    }
  } else {
    debugPrint('⚠️ Supabase keys missing. App is running in local-only mode.');
  }

  // Initialize IsarService — must be before any DAO access
  await IsarService.instance.open();

  // Initialize WorkManager for background usage sync
  await UsageSyncService.initialize();
  await UsageSyncService.registerPeriodicTask();

  runApp(
    const ProviderScope(
      child: FocusShieldApp(),
    ),
  );
}

class FocusShieldApp extends StatelessWidget {
  const FocusShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FocusShield',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return DebugNavigator(child: child);
      },
    );
  }
}
