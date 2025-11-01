part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartItemRemoved extends CartState {}

final class CartItemAdded extends CartState {}

final class CartLoading extends CartState {}

final class CartCleared extends CartState {}

final class CartFailure extends CartState {
  final String errMessage;
  CartFailure({required this.errMessage});
}

final class CartLoaded extends CartState {
  final List<CartItemModel> items;
  CartLoaded({required this.items});
}
