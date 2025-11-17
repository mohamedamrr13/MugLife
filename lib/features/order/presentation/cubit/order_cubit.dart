import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/order/data/models/order_model.dart';
import 'package:drinks_app/features/order/data/repository/order_repository.dart';
import 'package:flutter/foundation.dart';

part 'order_state.dart';

/// Cubit for managing orders
class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit(this._orderRepository) : super(OrderInitial());

  /// Create a new order
  Future<void> createOrder({required OrderModel order}) async {
    emit(OrderCreating());

    final result = await _orderRepository.createOrder(order: order);

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (orderId) => emit(OrderCreated(orderId: orderId)),
    );
  }

  /// Update an existing order
  Future<void> updateOrder({
    required String orderId,
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    emit(OrderLoading());

    final result = await _orderRepository.updateOrder(
      orderId: orderId,
      userId: userId,
      updates: updates,
    );

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (_) {
        emit(OrderUpdated());
        // Reload the order after update
        getOrder(orderId: orderId, userId: userId);
      },
    );
  }

  /// Update order status
  Future<void> updateOrderStatus({
    required String orderId,
    required String userId,
    required OrderStatus status,
  }) async {
    emit(OrderLoading());

    final result = await _orderRepository.updateOrderStatus(
      orderId: orderId,
      userId: userId,
      status: status,
    );

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (_) {
        emit(OrderStatusUpdated());
        // Reload the order after status update
        getOrder(orderId: orderId, userId: userId);
      },
    );
  }

  /// Get a specific order
  Future<void> getOrder({
    required String orderId,
    required String userId,
  }) async {
    emit(OrderLoading());

    final result = await _orderRepository.getOrder(
      orderId: orderId,
      userId: userId,
    );

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (order) => emit(OrderLoaded(order: order)),
    );
  }

  /// Get all orders for a user
  Future<void> getUserOrders({required String userId}) async {
    emit(OrderLoading());

    final result = await _orderRepository.getUserOrders(userId: userId);

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  /// Cancel an order
  Future<void> cancelOrder({
    required String orderId,
    required String userId,
  }) async {
    emit(OrderLoading());

    final result = await _orderRepository.cancelOrder(
      orderId: orderId,
      userId: userId,
    );

    result.fold(
      (failure) => emit(OrderFailure(errMessage: failure.message)),
      (_) {
        emit(OrderCancelled());
        // Reload user orders after cancellation
        getUserOrders(userId: userId);
      },
    );
  }
}
