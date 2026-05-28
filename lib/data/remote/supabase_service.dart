import 'package:supabase_flutter/supabase_flutter.dart';

/// Generic helper wrapping common postgrest CRUD operations 
/// with centralised error handling.
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  Future<List<Map<String, dynamic>>> select(String table, {String? matchKey, dynamic matchValue}) async {
    try {
      if (matchKey != null && matchValue != null) {
        return await _client.from(table).select().eq(matchKey, matchValue);
      }
      return await _client.from(table).select();
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data) async {
    try {
      return await _client.from(table).insert(data).select().single();
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> upsert(String table, Map<String, dynamic> data, {String? onConflict}) async {
    try {
      if (onConflict != null) {
        return await _client.from(table).upsert(data, onConflict: onConflict).select().single();
      }
      return await _client.from(table).upsert(data).select().single();
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<void> delete(String table, {required String matchKey, required dynamic matchValue}) async {
    try {
      await _client.from(table).delete().eq(matchKey, matchValue);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(dynamic error) {
    // Centralized error handling
    print('SupabaseService Error: $error');
  }
}
