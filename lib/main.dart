import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/supabase_options.dart';
import 'data/local/isar_service.dart';
// TODO: Uncomment after running 'flutterfire configure' to generate firebase_options.dart
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (for FCM only) - Uncomment after generating firebase_options.dart
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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

  // Initialize IsarService (Phase 0, Prompt 3)
  await IsarService.instance.open();

  // TODO: Initialize WorkManagerService (Phase 10, Prompt 23)
  // await WorkManagerService.initialize();

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
    );
  }
}
