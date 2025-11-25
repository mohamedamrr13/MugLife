import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/order/data/models/order_model.dart';
import 'package:drinks_app/features/order/data/repository/order_repository.dart';

/// Firestore implementation of OrderRepository
class FirestoreOrderRepository implements OrderRepository {
  final FirestoreService _firestoreService;

  FirestoreOrderRepository(this._firestoreService);

  /// Collection path for user orders: orders/{userId}/user_orders
  String _getOrdersPath(String userId) => 'orders/$userId/user_orders';

  @override
  Future<Either<Failure, String>> createOrder({
    required OrderModel order,
  }) async {
    try {
      final orderId = await _firestoreService.addDocument(
        collectionPath: _getOrdersPath(order.userId),
        data: order.toMap(),
      );
      return Right(orderId);
    } catch (e) {
      return Left(Failure(message: 'Failed to create order: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrder({
    required String orderId,
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Add updatedAt timestamp
      final updatesWithTimestamp = {
        ...updates,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      await _firestoreService.updateDocument(
        collectionPath: _getOrdersPath(userId),
        documentId: orderId,
        data: updatesWithTimestamp,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to update order: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String userId,
    required OrderStatus status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      // If status is delivered, add deliveredAt timestamp
      if (status == OrderStatus.delivered) {
        updates['deliveredAt'] = Timestamp.fromDate(DateTime.now());
      }

      await _firestoreService.updateDocument(
        collectionPath: _getOrdersPath(userId),
        documentId: orderId,
        data: updates,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to update order status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrder({
    required String orderId,
    required String userId,
  }) async {
    try {
      final doc = await _firestoreService.getDocument(
        collectionPath: _getOrdersPath(userId),
        documentId: orderId,
      );

      if (!doc.exists) {
        return Left(Failure(message: 'Order not found'));
      }

      final order = OrderModel.fromDocument(doc);
      return Right(order);
    } catch (e) {
      return Left(Failure(message: 'Failed to get order: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getUserOrders({
    required String userId,
  }) async {
    try {
      final docs = await _firestoreService.getAllDocuments(
        collectionPath: _getOrdersPath(userId),
      );

      final orders =
          docs.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

      // Sort by creation date (most recent first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(orders);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to get user orders: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder({
    required String orderId,
    required String userId,
  }) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _getOrdersPath(userId),
        documentId: orderId,
        data: {
          'status': OrderStatus.cancelled.name,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to cancel order: ${e.toString()}'));
    }
  }
}
