import 'package:drinks_app/features/product/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final DateTime addedAt;
  final String size;
  CartItemModel({
    required this.product,
    this.quantity = 1,
    required this.size,
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
      'size': size,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItemModel.fromDocument(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      product: ProductModel.fromDocument(doc),
      quantity: data['quantity'] ?? 1,
      size: data['size'] ?? 'M',
      addedAt: DateTime.parse(
        data['addedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
