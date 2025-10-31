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
  Future<void> addProduct(ProductModel item, int quantity, String size) async {
    final ProductModel itemWithSize = item.copyWith(size: size);
    debugPrint(
      'Adding product to cart: ${item.name} , ${(await isItemInCart(itemWithSize)).toString()}, user ID: ${await userId}  ',
    );
    if (await isItemInCart(itemWithSize)) {
      debugPrint('Item already in cart, updating quantity: ${item.name}');
      return _firestore
          .collection('cart')
          .doc(await userId)
          .collection('items')
          .where('product.name', isEqualTo: item.name)
          .where('product.size', isEqualTo: size)
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              final doc = querySnapshot.docs.first;
              final currentQuantity = doc['quantity'] ?? 1;
              debugPrint('Current quantity: $currentQuantity');
              return doc.reference
                  .update({'quantity': currentQuantity + quantity})
                  .then((_) {
                    debugPrint(
                      'Updated item quantity: ${item.name}, New quantity: ${currentQuantity + quantity}, size: $size',
                    );
                  });
            }
          })
          .catchError((error) {
            print('Error updating item quantity: $error');
          });
    } else {
      final cartItem = CartItemModel(
        product: item.copyWith(size: size),
        quantity: quantity,
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
        .where('product.size', isEqualTo: item.size)
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
  void clearCart() async {
    _firestore
        .collection('cart')
        .doc(await userId)
        .collection('items')
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
  }

  @override
  Future<int> getCartItemCount() async {
    final querySnapshot =
        await _firestore
            .collection('cart')
            .doc(await userId)
            .collection('items')
            .get();
    return querySnapshot.docs.length;
  }

  @override
  Stream<List<CartItemModel>> getCartItems() async* {
    yield* _firestore
        .collection('cart')
        .doc(await userId)
        .collection('items')
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return CartItemModel.fromDocument(doc);
          }).toList();
        });
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
