import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CartRepository {
  Stream<List<ProductModel>> getCartItems();
  Future<void> addToCart(ProductModel item);
  Future<void> updateCartItem(String itemId, int quantity);
  Future<void> removeFromCart(String itemId);
  Future<void> clearCart();
  Future<double> getCartTotal();
  Future<int> getCartItemCount();
}

class FirestoreCartRepository implements CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _cartCollection {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(_userId).collection('cart');
  }

  @override
  Stream<List<ProductModel>> getCartItems() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _cartCollection.orderBy('addedAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
      },
    );
  }

  @override
  Future<void> addToCart(ProductModel item) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    // Ensure item has cart-specific fields
    if (!item.isCartItem) {
      throw Exception('Product must be converted to cart item first');
    }

    // Check if item with same product ID and size already exists
    final existingQuery =
        await _cartCollection
            .where('name', isEqualTo: item.name)
            .where('size', isEqualTo: item.size)
            .get();

    if (existingQuery.docs.isNotEmpty) {
      // Update existing item quantity
      final existingDoc = existingQuery.docs.first;
      final existingItem = ProductModel.fromFirestore(existingDoc);
      await existingDoc.reference.update({
        'quantity': (existingItem.quantity ?? 0) + (item.quantity ?? 1),
      });
    } else {
      // Add new item
      await _cartCollection.add(item.toFirestore());
    }
  }

  @override
  Future<void> updateCartItem(String itemId, int quantity) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    await _cartCollection.doc(itemId).update({'quantity': quantity});
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _cartCollection.doc(itemId).delete();
  }

  @override
  Future<void> clearCart() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final batch = _firestore.batch();
    final cartItems = await _cartCollection.get();

    for (final doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Future<double> getCartTotal() async {
    if (_userId == null) {
      return 0.0;
    }

    final cartItems = await _cartCollection.get();
    double total = 0.0;

    for (final doc in cartItems.docs) {
      final item = ProductModel.fromFirestore(doc);
      total += item.totalPrice;
    }

    return total;
  }

  @override
  Future<int> getCartItemCount() async {
    if (_userId == null) {
      return 0;
    }

    final cartItems = await _cartCollection.get();
    int count = 0;

    for (final doc in cartItems.docs) {
      final item = ProductModel.fromFirestore(doc);
      count += item.quantity ?? 0;
    }

    return count;
  }
}

// Local storage implementation for offline support
class LocalCartRepository implements CartRepository {
  final List<ProductModel> _cartItems = [];

  @override
  Stream<List<ProductModel>> getCartItems() {
    return Stream.value(List.from(_cartItems));
  }

  @override
  Future<void> addToCart(ProductModel item) async {
    if (!item.isCartItem) {
      throw Exception('Product must be converted to cart item first');
    }

    final existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem.name == item.name && cartItem.size == item.size,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity:
            (_cartItems[existingIndex].quantity ?? 0) + (item.quantity ?? 1),
      );
    } else {
      _cartItems.add(
        item.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          addedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> updateCartItem(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    _cartItems.removeWhere((item) => item.id == itemId);
  }

  @override
  Future<void> clearCart() async {
    _cartItems.clear();
  }

@override
  Future<double> getCartTotal() async {
    double total = 0.0;
    for (final item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Future<int> getCartItemCount() async {
    int count = 0;
    for (final item in _cartItems) {
      count += item.quantity ?? 0;
    }
    return count;
  }
}
