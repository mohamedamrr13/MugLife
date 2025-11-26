import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// A standardized service for all Firestore CRUD operations
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  /// CREATE: Add a document to a collection
  /// Returns the document ID
  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collectionPath).add(data);
      debugPrint('✅ Document added to $collectionPath with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error adding document to $collectionPath: $e');
      rethrow;
    }
  }

  /// CREATE: Set a document with a specific ID
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));
      debugPrint('✅ Document set at $collectionPath/$documentId');
    } catch (e) {
      debugPrint('❌ Error setting document at $collectionPath/$documentId: $e');
      rethrow;
    }
  }

  /// READ: Get a single document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .get();
      debugPrint('✅ Document retrieved from $collectionPath/$documentId');
      return doc;
    } catch (e) {
      debugPrint('❌ Error getting document from $collectionPath/$documentId: $e');
      rethrow;
    }
  }

  /// READ: Get all documents from a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getAllDocuments({
    required String collectionPath,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      debugPrint('✅ Retrieved ${snapshot.docs.length} documents from $collectionPath');
      return snapshot;
    } catch (e) {
      debugPrint('❌ Error getting documents from $collectionPath: $e');
      rethrow;
    }
  }

  /// READ: Query documents with filters
  Future<QuerySnapshot<Map<String, dynamic>>> queryDocuments({
    required String collectionPath,
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

      // Apply filters
      if (filters != null) {
        for (final filter in filters) {
          query = query.where(
            filter.field,
            isEqualTo: filter.isEqualTo,
            isNotEqualTo: filter.isNotEqualTo,
            isLessThan: filter.isLessThan,
            isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
            arrayContains: filter.arrayContains,
            arrayContainsAny: filter.arrayContainsAny,
            whereIn: filter.whereIn,
            whereNotIn: filter.whereNotIn,
            isNull: filter.isNull,
          );
        }
      }

      // Apply ordering
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      debugPrint('✅ Query returned ${snapshot.docs.length} documents from $collectionPath');
      return snapshot;
    } catch (e) {
      debugPrint('❌ Error querying documents from $collectionPath: $e');
      rethrow;
    }
  }

  /// UPDATE: Update a document
  /// If the document doesn't exist, it will be created with the provided data
  Future<void> updateDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .set(data, SetOptions(merge: true));
      debugPrint('✅ Document updated at $collectionPath/$documentId');
    } catch (e) {
      debugPrint('❌ Error updating document at $collectionPath/$documentId: $e');
      rethrow;
    }
  }

  /// DELETE: Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .delete();
      debugPrint('✅ Document deleted from $collectionPath/$documentId');
    } catch (e) {
      debugPrint('❌ Error deleting document from $collectionPath/$documentId: $e');
      rethrow;
    }
  }

  /// DELETE: Delete all documents matching a query
  Future<void> deleteDocuments({
    required String collectionPath,
    List<QueryFilter>? filters,
  }) async {
    try {
      final snapshot = await queryDocuments(
        collectionPath: collectionPath,
        filters: filters,
      );

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('✅ Deleted ${snapshot.docs.length} documents from $collectionPath');
    } catch (e) {
      debugPrint('❌ Error deleting documents from $collectionPath: $e');
      rethrow;
    }
  }

  /// STREAM: Listen to real-time updates for a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    // Apply filters
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
    }

    // Apply ordering
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  /// STREAM: Listen to a specific document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(documentId)
        .snapshots();
  }

  /// Get a reference to a collection (useful for subcollections)
  CollectionReference<Map<String, dynamic>> getCollectionReference(
    String collectionPath,
  ) {
    return _firestore.collection(collectionPath);
  }

  /// Get a reference to a document (useful for subcollections)
  DocumentReference<Map<String, dynamic>> getDocumentReference(
    String documentPath,
  ) {
    return _firestore.doc(documentPath);
  }

  /// Batch write operations
  WriteBatch batch() {
    return _firestore.batch();
  }

  /// Transaction operations
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _firestore.runTransaction(transactionHandler, timeout: timeout);
  }
}

/// Helper class to build query filters
class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final List<dynamic>? whereNotIn;
  final bool? isNull;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}
