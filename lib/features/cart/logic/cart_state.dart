import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  const CartState({
    required this.items,
    this.isLoading = false,
    this.error,
  });

  factory CartState.initial() {
    return const CartState(items: []);
  }

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Computed properties
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.08; // 8% tax rate

  double get deliveryFee => subtotal > 50 ? 0.0 : 5.99; // Free delivery over $50

  double get total => subtotal + tax + deliveryFee;

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartState &&
        other.items == items &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return items.hashCode ^ isLoading.hashCode ^ error.hashCode;
  }

  @override
  String toString() {
    return 'CartState(items: ${items.length}, isLoading: $isLoading, error: $error)';
  }
}

