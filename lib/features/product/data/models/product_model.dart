import 'package:cloud_firestore/cloud_firestore.dart';

class SizeOption {
  final String name;
  final double priceModifier;

  const SizeOption({required this.name, required this.priceModifier});

  // Convert to Firestore format
  Map<String, dynamic> toMap() {
    return {'name': name, 'priceModifier': priceModifier};
  }

  // Create from Firestore format
  factory SizeOption.fromMap(Map<String, dynamic> map) {
    return SizeOption(
      name: map['name'] ?? '',
      priceModifier: _parseDouble(map['priceModifier']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

// ============================================
// ENHANCED PRODUCT MODEL
// ============================================
class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final double price; // This becomes the BASE price
  final bool isFeatured;
  final String? size; // Selected size for cart items
  final List<SizeOption> availableSizes; // Available sizes with pricing

  // Default sizes if not provided in Firestore
  static const List<SizeOption> defaultSizes = [
    SizeOption(name: 'Small', priceModifier: 0.0),
    SizeOption(name: 'Medium', priceModifier: 15.0),
    SizeOption(name: 'Large', priceModifier: 30.0),
  ];

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    this.isFeatured = false,
    this.size,
    this.availableSizes = defaultSizes,
  });

  // ============================================
  // PRICING METHODS
  // ============================================

  /// Get price for a specific size by name
  double getPriceForSize(String sizeName) {
    final sizeOption = availableSizes.firstWhere(
      (size) => size.name.toLowerCase() == sizeName.toLowerCase(),
      orElse: () => availableSizes.first,
    );
    return price + sizeOption.priceModifier;
  }

  /// Get price for a specific size by index
  double getPriceForSizeIndex(int index) {
    if (index < 0 || index >= availableSizes.length) {
      return price; // Return base price if index invalid
    }
    return price + availableSizes[index].priceModifier;
  }

  /// Get the current selected size price (for cart items)
  double get currentPrice {
    if (size == null) return price;
    return getPriceForSize(size!);
  }

  /// Get size index by name
  int getSizeIndex(String sizeName) {
    return availableSizes.indexWhere(
      (size) => size.name.toLowerCase() == sizeName.toLowerCase(),
    );
  }

  // ============================================
  // COPY WITH
  // ============================================

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? image,
    double? price,
    bool? isFeatured,
    String? size,
    List<SizeOption>? availableSizes,
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
      availableSizes: availableSizes ?? this.availableSizes,
    );
  }

  // ============================================
  // FIRESTORE SERIALIZATION
  // ============================================

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
      'size': size,
      'availableSizes': availableSizes.map((s) => s.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
      'size': size,
      'availableSizes': availableSizes.map((s) => s.toMap()).toList(),
    };
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse available sizes if they exist, otherwise use defaults
    List<SizeOption> sizes = defaultSizes;
    if (data['availableSizes'] != null) {
      try {
        sizes =
            (data['availableSizes'] as List)
                .map(
                  (sizeData) =>
                      SizeOption.fromMap(sizeData as Map<String, dynamic>),
                )
                .toList();
      } catch (e) {
        print('Error parsing sizes: $e');
        sizes = defaultSizes;
      }
    }

    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      price: _parseDouble(data['price']),
      isFeatured: _parseBool(data['isFeatured']),
      size: data['size'],
      availableSizes: sizes,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse available sizes if they exist, otherwise use defaults
    List<SizeOption> sizes = defaultSizes;
    if (json['availableSizes'] != null) {
      try {
        sizes =
            (json['availableSizes'] as List)
                .map(
                  (sizeData) =>
                      SizeOption.fromMap(sizeData as Map<String, dynamic>),
                )
                .toList();
      } catch (e) {
        print('Error parsing sizes: $e');
        sizes = defaultSizes;
      }
    }

    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      price: _parseDouble(json['price']),
      isFeatured: _parseBool(json['isFeatured']),
      size: json['size'],
      availableSizes: sizes,
    );
  }

  // Create from nested Firestore map (for cart items)
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    // Parse available sizes if they exist, otherwise use defaults
    List<SizeOption> sizes = defaultSizes;
    if (data['availableSizes'] != null) {
      try {
        sizes =
            (data['availableSizes'] as List)
                .map(
                  (sizeData) =>
                      SizeOption.fromMap(sizeData as Map<String, dynamic>),
                )
                .toList();
      } catch (e) {
        print('Error parsing sizes: $e');
        sizes = defaultSizes;
      }
    }

    return ProductModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      price: _parseDouble(data['price']),
      isFeatured: _parseBool(data['isFeatured']),
      size: data['size'],
      availableSizes: sizes,
    );
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value == 1;
    return false;
  }
}
