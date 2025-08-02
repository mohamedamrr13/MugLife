class CategoryModel {
  final String name;
  final String image;

  CategoryModel({required this.name, required this.image});

  /// Create from Firestore document (Map)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['name'] ?? '', image: json['image'] ?? '');
  }

  /// Convert to Map (optional, useful for adding to Firestore)
  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image};
  }
}
