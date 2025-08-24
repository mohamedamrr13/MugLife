import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/cart/logic/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  StreamSubscription<List<CartItemModel>>? _cartSubscription;

  CartCubit(this._cartRepository) : super(CartState.initial()) {
    _initializeCart();
  }

  void _initializeCart() {
    emit(state.copyWith(isLoading: true));
    _cartSubscription = _cartRepository.getCartItems().listen(
      (items) {
        emit(state.copyWith(
          items: items,
          isLoading: false,
          error: null,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load cart: ${error.toString()}',
        ));
      },
    );
  }

  Future<void> addToCart(CartItemModel item) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartRepository.addToCart(item);
      // The stream will automatically update the state
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to add item to cart: ${e.toString()}',
      ));
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      await _cartRepository.updateCartItem(itemId, quantity);
      // The stream will automatically update the state
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to update item quantity: ${e.toString()}',
      ));
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      await _cartRepository.removeFromCart(itemId);
      // The stream will automatically update the state
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to remove item from cart: ${e.toString()}',
      ));
    }
  }

  Future<void> clearCart() async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartRepository.clearCart();
      // The stream will automatically update the state
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to clear cart: ${e.toString()}',
      ));
    }
  }

  Future<void> incrementQuantity(String itemId) async {
    final item = state.items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity + 1);
  }

  Future<void> decrementQuantity(String itemId) async {
    final item = state.items.firstWhere((item) => item.id == itemId);
    if (item.quantity > 1) {
      await updateQuantity(itemId, item.quantity - 1);
    } else {
      await removeFromCart(itemId);
    }
  }

  // Getters for cart calculations
  double get subtotal {
    return state.items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.08; // 8% tax rate

  double get deliveryFee => subtotal > 50 ? 0.0 : 5.99; // Free delivery over $50

  double get total => subtotal + tax + deliveryFee;

  int get itemCount {
    return state.items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => state.items.isEmpty;

  bool get isLoading => state.isLoading;

  bool get hasError => state.error != null;

  String? get errorMessage => state.error;

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}

