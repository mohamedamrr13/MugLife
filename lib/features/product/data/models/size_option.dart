class SizeOption {
  final String name;
  final double priceModifier;

  const SizeOption({required this.name, required this.priceModifier});

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
