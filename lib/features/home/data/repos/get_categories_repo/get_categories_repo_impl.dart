import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/home/data/data_sources/local_data_source.dart';
import 'package:drinks_app/features/home/data/data_sources/remote_data_source.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
@override
class GetCategoriesRepoImpl implements GetCategoriesRepo {
  @override
  final HomeRemoteDataSource remoteDataSource;
  @override
  final HomeLocalDataSource localDataSource;

  GetCategoriesRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategoriesData();

      // Cache locally
      await localDataSource.cacheCategories(categories);

      return Right(categories);
    } on Exception catch (e) {
      // On error, try local cache
      final cached = await localDataSource.getCachedCategories();
      if (cached.isNotEmpty) {
        return Right(cached);
      }

      if (e is FirebaseException) {
        return Left(FirebaseErrorMapper.fromCode(e.message!));
      }
      return Left(Failure(message: e.toString()));
    }
  }
}
