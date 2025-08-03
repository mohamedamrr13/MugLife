part of 'get_featured_products_cubit.dart';

@immutable
sealed class GetFeaturedProductsState {}

final class GetFeaturedProductsInitial extends GetFeaturedProductsState {}

final class GetFeaturedProductsLoading extends GetFeaturedProductsState {}

final class GetFeaturedProductsSuccess extends GetFeaturedProductsState {
  final List<ProductModel> products;

  GetFeaturedProductsSuccess({required this.products});
}

final class GetFeaturedProductsFailure extends GetFeaturedProductsState {
  final String errMessage;

  GetFeaturedProductsFailure({required this.errMessage});
}
