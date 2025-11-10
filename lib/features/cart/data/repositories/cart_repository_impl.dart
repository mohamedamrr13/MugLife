import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreCartRepository implements CartRepository {
  final FirestoreService _firestoreService;
  FirestoreCartRepository(this._firestoreService);

  String get _cartPath {
    return 'cart/${FirebaseAuth.instance.currentUser?.uid}/items';
  }

  @override
  Future<void> addProduct(ProductModel item, int quantity, String size) async {
    final ProductModel itemWithSize = item.copyWith(size: size);
    debugPrint(
      'Adding product to cart: ${item.name} , ${(await isItemInCart(itemWithSize)).toString()},  ',
    );
    if (await isItemInCart(itemWithSize)) {
      debugPrint('Item already in cart, updating quantity: ${item.name}');
      final querySnapshot = await _firestoreService.queryDocuments(
        collectionPath: _cartPath,
        filters: [
          QueryFilter(field: 'product.name', isEqualTo: item.name),
          QueryFilter(field: 'product.size', isEqualTo: size),
        ],
      );

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final currentQuantity = doc['quantity'] ?? 1;
        debugPrint('Current quantity: $currentQuantity');

        await _firestoreService.updateDocument(
          collectionPath: _cartPath,
          documentId: doc.id,
          data: {
            'quantity': currentQuantity + quantity,
            'price': itemWithSize.price * (quantity + currentQuantity),
          },
        );

        debugPrint(
          'Updated item quantity: ${item.name}, New quantity: ${currentQuantity + quantity}, size: $size',
        );
      }
    } else {
      final cartItem = CartItemModel(
        product: item.copyWith(
          size: size,
          price: itemWithSize.price * quantity,
        ),
        quantity: quantity,
        addedAt: DateTime.now(),
      );

      await _firestoreService.addDocument(
        collectionPath: _cartPath,
        data: cartItem.toFirestore(),
      );
      debugPrint('Added new item to cart: ${item.name}');
    }
  }

  @override
  Future<bool> isItemInCart(ProductModel item) async {
    final querySnapshot = await _firestoreService.queryDocuments(
      collectionPath: _cartPath,
      filters: [
        QueryFilter(field: 'product.name', isEqualTo: item.name),
        QueryFilter(field: 'product.size', isEqualTo: item.size),
      ],
    );
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  void clearCart() async {
    await _firestoreService.deleteDocuments(collectionPath: _cartPath);
  }

  @override
  Future<int> getCartItemCount() async {
    final querySnapshot = await _firestoreService.getAllDocuments(
      collectionPath: _cartPath,
    );
    return querySnapshot.docs.length;
  }

  @override
  Stream<List<CartItemModel>> getCartItems() {
    return _firestoreService.streamCollection(collectionPath: _cartPath).map((
      querySnapshot,
    ) {
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
    final querySnapshot = await _firestoreService.getAllDocuments(
      collectionPath: _cartPath,
    );

    for (var doc in querySnapshot.docs) {
      final cartItem = CartItemModel.fromDocument(doc);
      total +=
          cartItem.product.getPriceForSize(cartItem.product.size!) *
          cartItem.quantity;
    }
    return total;
  }

  @override
  Future<void> removeFromCart(String itemId) {
    return _firestoreService.deleteDocument(
      collectionPath: _cartPath,
      documentId: itemId,
    );
  }

  @override
  Future<void> updateCartItem(CartItemModel model, int quantity) async {
    final querySnapshot = await _firestoreService.queryDocuments(
      collectionPath: _cartPath,
      filters: [
        QueryFilter(field: 'product.name', isEqualTo: model.product.name),
        QueryFilter(field: 'product.size', isEqualTo: model.product.size),
      ],
    );

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      debugPrint(
        'Updating item quantity: ${model.product.name}, New quantity: $quantity, size: ${model.product.size}',
      );
      await _firestoreService.updateDocument(
        collectionPath: _cartPath,
        documentId: doc.id,
        data: {
          'quantity': model.quantity + quantity,
          'price': model.quantity * model.product.price,
        },
      );
    }
  }

  @override
  Future<bool> isCartEmpty() async {
    final querySnapshot = await _firestoreService.getAllDocuments(
      collectionPath: _cartPath,
    );
    return querySnapshot.docs.isEmpty;
  }
}
