class ProductModel {
  String image;
  String name;
  String description;
  String category;
  int price;
  bool isFeatured;

  ProductModel({
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.isFeatured,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0, // Default to 0 if null
      isFeatured: _parseBool(json['isFeatured']), // Handle bool conversion
    );
  }

  // Helper method to safely convert dynamic value to bool
  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    } else if (value is int) {
      return value == 1; // Treat 1 as true, 0 as false
    }
    return false; // Default if parsing fails
  }
}
