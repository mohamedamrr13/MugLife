import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/home/data/data_sources/local_data_source.dart';
import 'package:drinks_app/features/home/data/data_sources/remote_data_source.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';

abstract class GetCategoriesRepo {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  GetCategoriesRepo({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
