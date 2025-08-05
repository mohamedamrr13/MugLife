import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:drinks_app/features/home/data/data_sources/local_data_source.dart';
import 'package:drinks_app/features/home/data/data_sources/remote_data_source.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo_impl.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  getIt.registerSingleton<HomeLocalDataSource>(HomeLocalDataSource());
  getIt.registerSingleton<HomeRemoteDataSource>(HomeRemoteDataSource());

  getIt.registerSingleton<GetCategoriesRepo>(
    GetCategoriesRepoImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );
}
