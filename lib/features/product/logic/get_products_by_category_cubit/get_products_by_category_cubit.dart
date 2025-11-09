import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo.dart';
import 'package:meta/meta.dart';

part 'get_products_by_category_state.dart';

class GetProductsByCategoryCubit extends Cubit<GetProductsByCategoryState> {
  GetProductsByCategoryCubit(this.getProductsByCategoryRepo)
    : super(GetProductsByCategoryInitial());

  final GetProductsByCategoryRepo getProductsByCategoryRepo;

  Future<void> getProductsByCategory(String category) async {
    emit(GetProductsByCategoryLoading());
    final result = await getProductsByCategoryRepo.getProductsByCategory(
      category,
    );
    result.fold(
      (failure) => emit(GetProductsByCategoryFailure(failure.message)),
      (success) => emit(GetProductsByCategorySuccess(success)),
    );
  }
}
