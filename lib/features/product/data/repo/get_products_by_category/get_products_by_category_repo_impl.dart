import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo.dart';

class GetProductsByCategoryRepoImpl implements GetProductsByCategoryRepo {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final snapshot =
          await db
              .collection('items')
              .where('category', isEqualTo: category)
              .get();
      final products =
          snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList();

      return Right(products);
    } on Exception catch (e) {
      if (e is FirebaseException) {
        return (Left(FirebaseErrorMapper.fromCode(e.code)));
      }
      return Left(Failure(message: e.toString()));
    }
  }
}
