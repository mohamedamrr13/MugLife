import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';

class GetCategoriesRepoImpl implements GetCategoriesRepo {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final snapshot =
          await db
              .collection("categories")
              .orderBy("createdAt", descending: false)
              .get();
      final categories =
          snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data()))
              .toList();
      return Right(categories);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FirebaseErrorMapper.fromCode(e.message!));
      }
      return Left(FirebaseErrorMapper.fromCode(e.toString()));
    }
  }
}
