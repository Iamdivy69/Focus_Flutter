// ignore_for_file: unused_import
// Firebase imports — uncomment after Firebase is configured (Phase 0, Prompt 2)
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/result.dart';
import '../../core/errors/failures.dart';

/// Wraps common Firestore CRUD operations.
/// All methods return [Result<T>] so callers never deal with raw exceptions.
///
/// Uncomment Firebase imports and implementations after running FlutterFire CLI.
class FirebaseService {
  // final FirebaseFirestore _firestore;
  // final FirebaseAuth _auth;

  // FirebaseService({
  //   required FirebaseFirestore firestore,
  //   required FirebaseAuth auth,
  // })  : _firestore = firestore,
  //       _auth = auth;

  // ---------------------------------------------------------------------------
  // Generic CRUD helpers
  // ---------------------------------------------------------------------------

  /// Set a document at [path] with [data], merging by default.
  Future<Result<void>> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    try {
      // await _firestore.doc(path).set(data, SetOptions(merge: merge));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Get a single document at [path].
  Future<Result<Map<String, dynamic>?>> getDocument(String path) async {
    try {
      // final snap = await _firestore.doc(path).get();
      // return Result.success(snap.data());
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Delete a document at [path].
  Future<Result<void>> deleteDocument(String path) async {
    try {
      // await _firestore.doc(path).delete();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Check whether a document at [path] exists.
  Future<Result<bool>> documentExists(String path) async {
    try {
      // final snap = await _firestore.doc(path).get();
      // return Result.success(snap.exists);
      return const Result.success(false);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Query a collection at [collectionPath] with optional ordering and limit.
  Future<Result<List<Map<String, dynamic>>>> queryCollection(
    String collectionPath, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      // var query = _firestore.collection(collectionPath) as Query;
      // if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
      // if (limit != null) query = query.limit(limit);
      // final snap = await query.get();
      // return Result.success(snap.docs.map((d) => d.data() as Map<String, dynamic>).toList());
      return const Result.success([]);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Stream a single document at [path].
  // Stream<Map<String, dynamic>?> streamDocument(String path) {
  //   return _firestore.doc(path).snapshots().map((snap) => snap.data());
  // }

  /// Stream a collection at [collectionPath].
  // Stream<List<Map<String, dynamic>>> streamCollection(String collectionPath) {
  //   return _firestore.collection(collectionPath).snapshots().map(
  //         (snap) => snap.docs.map((d) => d.data()).toList(),
  //       );
  // }
}
