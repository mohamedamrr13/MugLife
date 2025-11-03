import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreCartRepository implements CartRepository {
  final FirebaseFirestore _firestore;
  FirestoreCartRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _cartCollection {
    return _firestore
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('items');
  }

  @override
  Future<void> addProduct(ProductModel item, int quantity, String size) async {
    final ProductModel itemWithSize = item.copyWith(size: size);
    debugPrint(
      'Adding product to cart: ${item.name} , ${(await isItemInCart(itemWithSize)).toString()},  ',
    );
    if (await isItemInCart(itemWithSize)) {
      debugPrint('Item already in cart, updating quantity: ${item.name}');
      return _cartCollection
          .where('product.name', isEqualTo: item.name)
          .where('product.size', isEqualTo: size)
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              final doc = querySnapshot.docs.first;
              final currentQuantity = doc['quantity'] ?? 1;
              debugPrint('Current quantity: $currentQuantity');
              return doc.reference
                  .update({
                    'quantity': currentQuantity + quantity,
                    'price': itemWithSize.price * (quantity + currentQuantity),
                  })
                  .then((_) {
                    debugPrint(
                      'Updated item quantity: ${item.name}, New quantity: ${currentQuantity + quantity}, size: $size',
                    );
                  });
            }
          })
          .catchError((error) {
            debugPrint('Error updating item quantity: $error');
          });
    } else {
      final cartItem = CartItemModel(
        product: item.copyWith(
          size: size,
          price: itemWithSize.price * quantity,
        ),
        quantity: quantity,
        addedAt: DateTime.now(),
      );

      _cartCollection.add(cartItem.toFirestore());
      debugPrint('Added new item to cart: ${item.name}');
    }
  }

  @override
  Future<bool> isItemInCart(ProductModel item) async {
    return _cartCollection
        .where('product.name', isEqualTo: item.name)
        .where('product.size', isEqualTo: item.size)
        .get()
        .then((querySnapshot) {
          return querySnapshot.docs.isNotEmpty;
        });
  }

  @override
  void clearCart() async {
    _cartCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<int> getCartItemCount() async {
    final querySnapshot = await _cartCollection.get();
    return querySnapshot.docs.length;
  }

  @override
  Stream<List<CartItemModel>> getCartItems() {
    return _cartCollection.snapshots().map((querySnapshot) {
      print('📦 Query snapshot docs count: ${querySnapshot.docs.length}');
      final items =
          querySnapshot.docs.map((doc) {
            print('📦 Document data: ${doc.data()}');
            return CartItemModel.fromDocument(doc);
          }).toList();
      print('📦 Total items parsed: ${items.length}');
      return items;
    });
  }

  @override
  Future<double> getCartTotal() async {
    double total = 0.0;
    await _cartCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final cartItem = CartItemModel.fromDocument(doc);
        total +=
            cartItem.product.getPriceForSize(cartItem.product.size!) *
            cartItem.quantity;
      }
    });
    return total;
  }

  @override
  Future<void> removeFromCart(String itemId) {
    return _cartCollection.doc(itemId).delete();
  }

  @override
  Future<void> updateCartItem(CartItemModel model, int quantity) {
    return _cartCollection
        .where('product.name', isEqualTo: model.product.name)
        .where('product.size', isEqualTo: model.product.size)
        .get()
        .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            final doc = querySnapshot.docs.first;
            debugPrint(
              'Updating item quantity: ${model.product.name}, New quantity: $quantity, size: ${model.product.size}',
            );
            return doc.reference.update({
              'quantity': model.quantity + quantity,
              'price': model.quantity * model.product.price,
            });
          }
        });
  }

  @override
  Future<bool> isCartEmpty() {
    return _cartCollection.get().then((querySnapshot) {
      return querySnapshot.docs.isEmpty;
    });
  }
}
