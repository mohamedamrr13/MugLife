import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final String size;
  final Map<String, dynamic>? customizations;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.size,
    this.customizations,
    required this.addedAt,
  });

  double get totalPrice => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? description,
    String? image,
    double? price,
    int? quantity,
    String? size,
    Map<String, dynamic>? customizations,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      customizations: customizations ?? this.customizations,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'customizations': customizations,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'customizations': customizations,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Factory constructor for creating from Firestore document
  factory CartItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 1,
      size: data['size'] ?? '',
      customizations: data['customizations'],
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Factory constructor for creating from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? '',
      customizations: json['customizations'],
      addedAt: json['addedAt'] is String 
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productId == productId &&
        other.size == size;
  }

  @override
  int get hashCode {
    return id.hashCode ^ productId.hashCode ^ size.hashCode;
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, name: $name, price: $price, quantity: $quantity, size: $size, addedAt: $addedAt)';
  }
}

