import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final double price;
  final bool isFeatured;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    this.isFeatured = false,
  });

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
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
