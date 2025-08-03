import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';

class GetFeaturedProductsRepoImpl implements GetFeaturedProductsRepo {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<ProductModel>>> getFeaturedProducts() async {
    try {
      final snapshot =
          await db
              .collection('items')
              .where('isFeatured', isEqualTo: true)
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
