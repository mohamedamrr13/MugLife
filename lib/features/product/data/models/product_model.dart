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
      category: json['category'],
      image: json['image'],
      price: json['price'],
      isFeatured: json['isFeatured'],
    );
  }
}
