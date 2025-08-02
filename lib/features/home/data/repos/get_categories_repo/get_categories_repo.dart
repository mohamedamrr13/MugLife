import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';

abstract class GetCategoriesRepo {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
