part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderCreating extends OrderState {}

final class OrderCreated extends OrderState {
  final String orderId;
  OrderCreated({required this.orderId});
}

final class OrderUpdated extends OrderState {}

final class OrderStatusUpdated extends OrderState {}

final class OrderCancelled extends OrderState {}

final class OrderLoaded extends OrderState {
  final OrderModel order;
  OrderLoaded({required this.order});
}

final class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

final class OrderFailure extends OrderState {
  final String errMessage;
  OrderFailure({required this.errMessage});
}
