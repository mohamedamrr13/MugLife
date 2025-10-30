import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final double price;
  final bool isFeatured;
  final String? size;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    this.isFeatured = false,
    this.size = 'Medium',
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? image,
    double? price,
    bool? isFeatured,
    String? size,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      isFeatured: isFeatured ?? this.isFeatured,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
      'size': size,
    };

    return map;
  }

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

    return map;
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      price: _parseDouble(data['price']),
      isFeatured: _parseBool(data['isFeatured']),
      size: data['size'] ?? 'Medium',
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      price: _parseDouble(json['price']),
      isFeatured: _parseBool(json['isFeatured']),
      size: json['size'] ?? 'Medium',
    );
  }

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
}
