import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a user's delivery address
class AddressModel {
  final String? id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final bool isDefault;
  final DateTime createdAt;

  AddressModel({
    this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create AddressModel from Firestore DocumentSnapshot
  factory AddressModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      city: data['city'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Create AddressModel from Firestore data
  factory AddressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AddressModel(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      city: data['city'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert AddressModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Convert AddressModel to Map for Firestore (without id)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Get formatted full address
  String get fullAddress {
    return '$addressLine1, $addressLine2, $city';
  }

  /// Get formatted address with name and phone
  String get fullAddressWithDetails {
    return '$name\n$phone\n$addressLine1, $addressLine2, $city';
  }

  /// Create a copy with updated fields
  AddressModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, name: $name, phone: $phone, address: $fullAddress, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        addressLine1.hashCode ^
        addressLine2.hashCode ^
        city.hashCode ^
        isDefault.hashCode;
  }
}
