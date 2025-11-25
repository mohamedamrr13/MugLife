import 'package:drinks_app/features/product/data/models/product_model.dart';

/// Model representing an item in an order
class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String size;
  final double pricePerUnit;
  final int quantity;
  final double totalPrice;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.size,
    required this.pricePerUnit,
    required this.quantity,
    required this.totalPrice,
  });

  /// Create OrderItemModel from a ProductModel and quantity
  factory OrderItemModel.fromProduct({
    required ProductModel product,
    required String size,
    required int quantity,
  }) {
    final pricePerUnit = product.getPriceForSize(size);
    return OrderItemModel(
      productId: product.id,
      productName: product.name,
      productImage: product.image,
      size: size,
      pricePerUnit: pricePerUnit,
      quantity: quantity,
      totalPrice: pricePerUnit * quantity,
    );
  }

  /// Create OrderItemModel from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      size: json['size'] ?? '',
      pricePerUnit: (json['pricePerUnit'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  /// Create OrderItemModel from Firestore data
  factory OrderItemModel.fromFirestore(Map<String, dynamic> data) {
    return OrderItemModel(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      size: data['size'] ?? '',
      pricePerUnit: (data['pricePerUnit'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 0,
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  /// Convert OrderItemModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'size': size,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  /// Convert OrderItemModel to Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'size': size,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  /// Create a copy with updated fields
  OrderItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? size,
    double? pricePerUnit,
    int? quantity,
    double? totalPrice,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      size: size ?? this.size,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  String toString() {
    return 'OrderItemModel(productName: $productName, size: $size, quantity: $quantity, total: \$$totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItemModel &&
        other.productId == productId &&
        other.size == size &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^ size.hashCode ^ quantity.hashCode;
  }
}
