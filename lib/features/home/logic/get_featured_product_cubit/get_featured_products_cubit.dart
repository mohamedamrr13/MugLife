import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:meta/meta.dart';

part 'get_featured_products_state.dart';

class GetFeaturedProductsCubit extends Cubit<GetFeaturedProductsState> {
  GetFeaturedProductsCubit(this.getFeaturedProductsRepoImpl)
    : super(GetFeaturedProductsInitial());

  final GetFeaturedProductsRepoImpl getFeaturedProductsRepoImpl;

  Future<void> getFeaturedProducts() async {
    emit(GetFeaturedProductsLoading());
    final result = await getFeaturedProductsRepoImpl.getFeaturedProducts();
    result.fold(
      (failure) =>
          emit(GetFeaturedProductsFailure(errMessage: failure.message)),
      (success) => emit(GetFeaturedProductsSuccess(products: success)),
    );
  }
}
