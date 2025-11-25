import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/order/data/models/order_model.dart';

/// Abstract repository for order operations
abstract class OrderRepository {
  Future<Either<Failure, String>> createOrder({required OrderModel order});

  Future<Either<Failure, void>> updateOrder({
    required String orderId,
    required String userId,
    required Map<String, dynamic> updates,
  });

  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String userId,
    required OrderStatus status,
  });

  Future<Either<Failure, OrderModel>> getOrder({
    required String orderId,
    required String userId,
  });

  Future<Either<Failure, List<OrderModel>>> getUserOrders({
    required String userId,
  });

  Future<Either<Failure, void>> cancelOrder({
    required String orderId,
    required String userId,
  });
}
