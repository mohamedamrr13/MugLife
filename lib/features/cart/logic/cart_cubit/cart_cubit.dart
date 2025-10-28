import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepository) : super(CartInitial());
  final CartRepository cartRepository;

  Future<void> addProductToCart(product, qunatity, size) async {
    emit(CartLoading());
    try {
      await cartRepository.addProduct(product, qunatity, size);
      emit(CartItemAdded());
    } on FirebaseException catch (e) {
      emit(CartFailure(errMessage: e.message ?? "An error occurred"));
    } catch (e) {
      emit(CartFailure(errMessage: e.toString()));
    }
  }

  Future<bool> isCartEmpty() async {
    try {
      return await cartRepository.isCartEmpty();
    } catch (e) {
      emit(CartFailure(errMessage: e.toString()));
      return true;
    }
  }
}
