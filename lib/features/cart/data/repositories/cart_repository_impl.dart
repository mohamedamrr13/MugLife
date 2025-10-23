import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreCartRepository implements CartRepository {
  final FirebaseFirestore _firestore;

  FirestoreCartRepository(this._firestore);
  Future<String?> get userId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Future<void> addProduct(ProductModel item) async {
    debugPrint(
      'Adding product to cart: ${item.name} , ${(await isItemInCart(item)).toString()}, user ID: ${await userId}  ',
    );
    if (await isItemInCart(item)) {
      return _firestore
          .collection('cart')
          .doc(await userId)
          .collection('items')
          .where('product.name', isEqualTo: item.name)
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              final doc = querySnapshot.docs.first;
              final currentQuantity = doc['quantity'] ?? 1;
              debugPrint('Current quantity: $currentQuantity');
              return doc.reference.update({'quantity': currentQuantity + 1});
            }
          })
          .catchError((error) {
            print('Error updating item quantity: $error');
          });
    } else {
      final cartItem = CartItemModel(
        product: item,
        quantity: 1,
        size: 'M',
        addedAt: DateTime.now(),
      );
      _firestore
          .collection('cart')
          .doc(await userId)
          .collection('items')
          .add(cartItem.toFirestore());
      debugPrint('Added new item to cart: ${item.name}');
    }
  }

  @override
  Future<bool> isItemInCart(ProductModel item) async {
    return _firestore
        .collection('cart')
        .doc(await userId)
        .collection('items')
        .where('product.name', isEqualTo: item.name)
        .get()
        .then((querySnapshot) {
          return querySnapshot.docs.isNotEmpty;
        })
        .catchError((error) {
          debugPrint('Error checking item in cart: $error');
          return false;
        });
  }

  @override
  void clearCart() {
    _firestore.collection('cart').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<int> getCartItemCount() {
    // TODO: implement getCartItemCount
    throw UnimplementedError();
  }

  @override
  Stream<List<CartItemModel>> getCartItems() {
    // TODO: implement getCartItems
    throw UnimplementedError();
  }

  @override
  Future<double> getCartTotal() {
    // TODO: implement getCartTotal
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromCart(String itemId) {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }

  @override
  Future<void> updateCartItem(String itemId, int quantity) {
    // TODO: implement updateCartItem
    throw UnimplementedError();
  }

  @override
  Future<bool> isCartEmpty() {
    return _firestore
        .collection('cart')
        .doc(userId.toString())
        .collection('items')
        .get()
        .then((querySnapshot) {
          return querySnapshot.docs.isEmpty;
        })
        .catchError((error) {
          print('Error checking if cart is empty: $error');
          return false;
        });
  }
}
