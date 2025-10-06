import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final double price;
  final bool isFeatured;

  // Cart-specific fields (optional, null when used as product)
  final int? quantity;
  final String? size;
  final Map<String, dynamic>? customizations;
  final DateTime? addedAt;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    this.isFeatured = false,
    this.quantity,
    this.size,
    this.customizations,
    this.addedAt,
  });

  // Computed properties
  bool get isCartItem => quantity != null && quantity! > 0;
  double get totalPrice => price * (quantity ?? 1);

  // Copy with method for easy modifications
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? image,
    double? price,
    bool? isFeatured,
    int? quantity,
    String? size,
    Map<String, dynamic>? customizations,
    DateTime? addedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      isFeatured: isFeatured ?? this.isFeatured,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      customizations: customizations ?? this.customizations,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Convert product to cart item
  ProductModel toCartItem({
    required int quantity,
    required String size,
    Map<String, dynamic>? customizations,
  }) {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      category: category,
      image: image,
      price: price,
      isFeatured: isFeatured,
      quantity: quantity,
      size: size,
      customizations: customizations,
      addedAt: DateTime.now(),
    );
  }

  // Convert to Map for Firestore (product or cart item)
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
    };

    // Add cart-specific fields if they exist
    if (quantity != null) map['quantity'] = quantity!;
    if (size != null) map['size'] = size!;
    if (customizations != null) map['customizations'] = customizations!;
    if (addedAt != null) map['addedAt'] = Timestamp.fromDate(addedAt!);

    return map;
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
    };

    // Add cart-specific fields if they exist
    if (quantity != null) map['quantity'] = quantity!;
    if (size != null) map['size'] = size!;
    if (customizations != null) map['customizations'] = customizations!;
    if (addedAt != null) map['addedAt'] = addedAt!.toIso8601String();

    return map;
  }

  // Factory constructor for creating from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      price: _parseDouble(data['price']),
      isFeatured: _parseBool(data['isFeatured']),
      quantity: data['quantity'] as int?,
      size: data['size'] as String?,
      customizations: data['customizations'] as Map<String, dynamic>?,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Factory constructor for creating from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      price: _parseDouble(json['price']),
      isFeatured: _parseBool(json['isFeatured']),
      quantity: json['quantity'] as int?,
      size: json['size'] as String?,
      customizations: json['customizations'] as Map<String, dynamic>?,
      addedAt:
          json['addedAt'] is String ? DateTime.parse(json['addedAt']) : null,
    );
  }

  // Helper method to safely convert dynamic value to double
  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Helper method to safely convert dynamic value to bool
  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    } else if (value is int) {
      return value == 1;
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.size == size;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ (size?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, category: $category, price: $price, quantity: $quantity, size: $size)';
  }
}
