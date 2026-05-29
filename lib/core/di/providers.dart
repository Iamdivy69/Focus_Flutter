import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/local/isar_service.dart';

// ---------------------------------------------------------------------------
// Infrastructure providers
// ---------------------------------------------------------------------------

/// Provides the Supabase client. Throws if Supabase is not initialised.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provides the IsarService singleton.
/// Useful for tests and providers that need direct DB access.
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});

// ---------------------------------------------------------------------------
// App-wide state
// ---------------------------------------------------------------------------

/// Tracks whether the app is fully initialised (Supabase, Isar ready).
final appInitialisedProvider = StateProvider<bool>((ref) => false);
