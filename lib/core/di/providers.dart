import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// ---------------------------------------------------------------------------
// Supabase providers
// ---------------------------------------------------------------------------

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ---------------------------------------------------------------------------
// Repository placeholders (to be implemented later)
// ---------------------------------------------------------------------------

final authRepositoryProvider = Provider<dynamic>((ref) {
  throw UnimplementedError('authRepositoryProvider not implemented yet');
});

final friendRepositoryProvider = Provider<dynamic>((ref) {
  throw UnimplementedError('friendRepositoryProvider not implemented yet');
});

final dailyReportRepositoryProvider = Provider<dynamic>((ref) {
  throw UnimplementedError('dailyReportRepositoryProvider not implemented yet');
});

// ---------------------------------------------------------------------------
// Firebase providers (FCM only)
// ---------------------------------------------------------------------------

// final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
//   return FirebaseMessaging.instance;
// });

// ---------------------------------------------------------------------------
// App state providers
// ---------------------------------------------------------------------------

/// Tracks whether the app is fully initialised (Supabase, FCM, Isar ready).
final appInitialisedProvider = StateProvider<bool>((ref) => false);
