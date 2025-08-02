import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';

abstract class GetProductsByCategoryRepo {
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String category);
}
