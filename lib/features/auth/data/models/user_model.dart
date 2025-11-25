import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a user with profile and delivery information
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final List<String> addressIds; // References to address documents
  final String? defaultAddressId;
  final int ordersCount;
  final double totalSpent;
  final int rewardPoints;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    List<String>? addressIds,
    this.defaultAddressId,
    this.ordersCount = 0,
    this.totalSpent = 0.0,
    this.rewardPoints = 0,
    DateTime? createdAt,
    this.updatedAt,
  })  : addressIds = addressIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      addressIds: List<String>.from(data['addressIds'] ?? []),
      defaultAddressId: data['defaultAddressId'],
      ordersCount: data['ordersCount'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0.0).toDouble(),
      rewardPoints: data['rewardPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      addressIds: List<String>.from(json['addressIds'] ?? []),
      defaultAddressId: json['defaultAddressId'],
      ordersCount: json['ordersCount'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      rewardPoints: json['rewardPoints'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// Create UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      addressIds: List<String>.from(data['addressIds'] ?? []),
      defaultAddressId: data['defaultAddressId'],
      ordersCount: data['ordersCount'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0.0).toDouble(),
      rewardPoints: data['rewardPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'addressIds': addressIds,
      if (defaultAddressId != null) 'defaultAddressId': defaultAddressId,
      'ordersCount': ordersCount,
      'totalSpent': totalSpent,
      'rewardPoints': rewardPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Convert UserModel to Map for Firestore (without id)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'addressIds': addressIds,
      if (defaultAddressId != null) 'defaultAddressId': defaultAddressId,
      'ordersCount': ordersCount,
      'totalSpent': totalSpent,
      'rewardPoints': rewardPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    List<String>? addressIds,
    String? defaultAddressId,
    int? ordersCount,
    double? totalSpent,
    int? rewardPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      addressIds: addressIds ?? this.addressIds,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      ordersCount: ordersCount ?? this.ordersCount,
      totalSpent: totalSpent ?? this.totalSpent,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Add an address ID to the user's address list
  UserModel addAddress(String addressId, {bool setAsDefault = false}) {
    final updatedAddressIds = List<String>.from(addressIds);
    if (!updatedAddressIds.contains(addressId)) {
      updatedAddressIds.add(addressId);
    }
    return copyWith(
      addressIds: updatedAddressIds,
      defaultAddressId: setAsDefault ? addressId : defaultAddressId,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove an address ID from the user's address list
  UserModel removeAddress(String addressId) {
    final updatedAddressIds = List<String>.from(addressIds)
      ..remove(addressId);
    return copyWith(
      addressIds: updatedAddressIds,
      defaultAddressId: defaultAddressId == addressId ? null : defaultAddressId,
      updatedAt: DateTime.now(),
    );
  }

  /// Update the default address
  UserModel setDefaultAddress(String addressId) {
    if (!addressIds.contains(addressId)) {
      throw ArgumentError('Address ID not found in user addresses');
    }
    return copyWith(
      defaultAddressId: addressId,
      updatedAt: DateTime.now(),
    );
  }

  /// Increment order count and update total spent
  UserModel incrementOrderStats(double orderTotal) {
    return copyWith(
      ordersCount: ordersCount + 1,
      totalSpent: totalSpent + orderTotal,
      rewardPoints: rewardPoints + (orderTotal ~/ 10), // 1 point per $10
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, addressIds: ${addressIds.length}, orders: $ordersCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }
}
