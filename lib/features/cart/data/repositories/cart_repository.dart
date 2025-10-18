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
