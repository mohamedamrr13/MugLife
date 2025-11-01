import 'package:drinks_app/features/product/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final DateTime addedAt;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  void incrementQuantity() {
    quantity += 1;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity -= 1;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'product': product.toFirestore(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItemModel.fromDocument(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;

    // ✅ CORRECT: Extract the nested product data
    final productData = data['product'] as Map<String, dynamic>;

    return CartItemModel(
      // Parse product from the nested product data, not the entire document
      product: ProductModel.fromJson(productData),
      quantity: data['quantity'] ?? 1,
      addedAt: DateTime.parse(
        data['addedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
