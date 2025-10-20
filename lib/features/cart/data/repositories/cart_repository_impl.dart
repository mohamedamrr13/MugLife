import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      return Stream.error(Exception('User not authenticated'));
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

    if (!item.isCartItem) {
      throw Exception('Product must be converted to cart item first');
    }

    if (item.id.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }

    // Check if item with same product ID and size already exists
    final existingQuery =
        await _cartCollection
            .where('productId', isEqualTo: item.id)
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
      // Add new item with addedAt timestamp
      final itemData = item.toFirestore();
      itemData['productId'] = item.id;
      itemData['addedAt'] = FieldValue.serverTimestamp();
      await _cartCollection.add(itemData);
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

    try {
      final cartItems = await _cartCollection.get();
      double total = 0.0;

      for (final doc in cartItems.docs) {
        final item = ProductModel.fromFirestore(doc);
        total += item.totalPrice;
      }

      return total;
    } catch (e) {
      throw Exception('Failed to calculate cart total: $e');
    }
  }

  @override
  Future<int> getCartItemCount() async {
    if (_userId == null) {
      return 0;
    }

    try {
      final cartItems = await _cartCollection.get();
      int count = 0;

      for (final doc in cartItems.docs) {
        final item = ProductModel.fromFirestore(doc);
        count += item.quantity ?? 0;
      }

      return count;
    } catch (e) {
      throw Exception('Failed to get cart item count: $e');
    }
  }
}
