import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';

abstract class CartRepository {
  Stream<List<CartItemModel>> getCartItems();
  Future<void> addProduct(ProductModel item);
  Future<void> updateCartItem(String itemId, int quantity);
  Future<void> removeFromCart(String itemId);
  void clearCart();
  Future<double> getCartTotal();
  Future<int> getCartItemCount();
  Future<bool> isItemInCart(ProductModel item);
  Future<bool> isCartEmpty();
}
