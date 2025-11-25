import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/order/data/models/order_item_model.dart';

/// Enum for order status
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

/// Enum for payment method
enum PaymentMethod {
  card,
  cash,
}

/// Model representing a customer order
class OrderModel {
  final String? id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final String? paymentTransactionId;
  final bool isPaid;

  // Shipping details
  final String shippingName;
  final String shippingPhone;
  final String shippingAddressLine1;
  final String shippingAddressLine2;
  final String shippingCity;
  final String? addressId; // Reference to saved address

  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveredAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0.0,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    required this.paymentMethod,
    this.paymentTransactionId,
    this.isPaid = false,
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddressLine1,
    required this.shippingAddressLine2,
    required this.shippingCity,
    this.addressId,
    DateTime? createdAt,
    this.updatedAt,
    this.deliveredAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create OrderModel from Firestore DocumentSnapshot
  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: _parseOrderStatus(data['status']),
      paymentMethod: _parsePaymentMethod(data['paymentMethod']),
      paymentTransactionId: data['paymentTransactionId'],
      isPaid: data['isPaid'] ?? false,
      shippingName: data['shippingName'] ?? '',
      shippingPhone: data['shippingPhone'] ?? '',
      shippingAddressLine1: data['shippingAddressLine1'] ?? '',
      shippingAddressLine2: data['shippingAddressLine2'] ?? '',
      shippingCity: data['shippingCity'] ?? '',
      addressId: data['addressId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      deliveredAt: (data['deliveredAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: _parseOrderStatus(json['status']),
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      paymentTransactionId: json['paymentTransactionId'],
      isPaid: json['isPaid'] ?? false,
      shippingName: json['shippingName'] ?? '',
      shippingPhone: json['shippingPhone'] ?? '',
      shippingAddressLine1: json['shippingAddressLine1'] ?? '',
      shippingAddressLine2: json['shippingAddressLine2'] ?? '',
      shippingCity: json['shippingCity'] ?? '',
      addressId: json['addressId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
    );
  }

  /// Create OrderModel from Firestore data
  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromFirestore(item))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: _parseOrderStatus(data['status']),
      paymentMethod: _parsePaymentMethod(data['paymentMethod']),
      paymentTransactionId: data['paymentTransactionId'],
      isPaid: data['isPaid'] ?? false,
      shippingName: data['shippingName'] ?? '',
      shippingPhone: data['shippingPhone'] ?? '',
      shippingAddressLine1: data['shippingAddressLine1'] ?? '',
      shippingAddressLine2: data['shippingAddressLine2'] ?? '',
      shippingCity: data['shippingCity'] ?? '',
      addressId: data['addressId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      deliveredAt: (data['deliveredAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert OrderModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      if (paymentTransactionId != null)
        'paymentTransactionId': paymentTransactionId,
      'isPaid': isPaid,
      'shippingName': shippingName,
      'shippingPhone': shippingPhone,
      'shippingAddressLine1': shippingAddressLine1,
      'shippingAddressLine2': shippingAddressLine2,
      'shippingCity': shippingCity,
      if (addressId != null) 'addressId': addressId,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (deliveredAt != null) 'deliveredAt': Timestamp.fromDate(deliveredAt!),
    };
  }

  /// Convert OrderModel to Map for Firestore (without id)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      if (paymentTransactionId != null)
        'paymentTransactionId': paymentTransactionId,
      'isPaid': isPaid,
      'shippingName': shippingName,
      'shippingPhone': shippingPhone,
      'shippingAddressLine1': shippingAddressLine1,
      'shippingAddressLine2': shippingAddressLine2,
      'shippingCity': shippingCity,
      if (addressId != null) 'addressId': addressId,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (deliveredAt != null) 'deliveredAt': Timestamp.fromDate(deliveredAt!),
    };
  }

  /// Get total number of items in the order
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get formatted shipping address
  String get shippingAddress {
    return '$shippingAddressLine1, $shippingAddressLine2, $shippingCity';
  }

  /// Get full shipping details
  String get fullShippingDetails {
    return '$shippingName\n$shippingPhone\n$shippingAddress';
  }

  /// Get order status display text
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get payment method display text
  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.card:
        return 'Card Payment';
      case PaymentMethod.cash:
        return 'Cash on Delivery';
    }
  }

  /// Create a copy with updated fields
  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? totalAmount,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    String? paymentTransactionId,
    bool? isPaid,
    String? shippingName,
    String? shippingPhone,
    String? shippingAddressLine1,
    String? shippingAddressLine2,
    String? shippingCity,
    String? addressId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      isPaid: isPaid ?? this.isPaid,
      shippingName: shippingName ?? this.shippingName,
      shippingPhone: shippingPhone ?? this.shippingPhone,
      shippingAddressLine1: shippingAddressLine1 ?? this.shippingAddressLine1,
      shippingAddressLine2: shippingAddressLine2 ?? this.shippingAddressLine2,
      shippingCity: shippingCity ?? this.shippingCity,
      addressId: addressId ?? this.addressId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  /// Helper to parse OrderStatus from string
  static OrderStatus _parseOrderStatus(dynamic value) {
    if (value == null) return OrderStatus.pending;
    if (value is OrderStatus) return value;
    try {
      return OrderStatus.values.firstWhere(
        (e) => e.name == value.toString().toLowerCase(),
        orElse: () => OrderStatus.pending,
      );
    } catch (_) {
      return OrderStatus.pending;
    }
  }

  /// Helper to parse PaymentMethod from string
  static PaymentMethod _parsePaymentMethod(dynamic value) {
    if (value == null) return PaymentMethod.cash;
    if (value is PaymentMethod) return value;
    try {
      return PaymentMethod.values.firstWhere(
        (e) => e.name == value.toString().toLowerCase(),
        orElse: () => PaymentMethod.cash,
      );
    } catch (_) {
      return PaymentMethod.cash;
    }
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, items: ${items.length}, total: \$$totalAmount, status: $statusText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel && other.id == id && other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode;
  }
}
