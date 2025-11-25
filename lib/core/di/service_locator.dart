import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/auth/data/repository/address_repository.dart';
import 'package:drinks_app/features/auth/data/repository/firestore_address_repository.dart';
import 'package:drinks_app/features/auth/data/repository/firestore_user_repository.dart';
import 'package:drinks_app/features/auth/data/repository/user_repository.dart';
import 'package:drinks_app/features/auth/presentation/cubit/address_cubit.dart';
import 'package:drinks_app/features/auth/presentation/cubit/user_cubit.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/order/data/repository/firestore_order_repository.dart';
import 'package:drinks_app/features/order/data/repository/order_repository.dart';
import 'package:drinks_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo_impl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:drinks_app/features/home/data/data_sources/local_data_source.dart';
import 'package:drinks_app/features/home/data/data_sources/remote_data_source.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo_impl.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  // Core services
  getIt.registerSingleton<FirestoreService>(
    FirestoreService(FirebaseFirestore.instance),
  );

  getIt.registerSingleton<FirebaseStorage>(
    FirebaseStorage.instance,
  );

  // Data sources
  getIt.registerSingleton<HomeLocalDataSource>(HomeLocalDataSource());
  getIt.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSource(getIt<FirestoreService>()),
  );

  // Repositories
  getIt.registerSingleton<GetCategoriesRepo>(
    GetCategoriesRepoImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );

  getIt.registerSingleton<GetFeaturedProductsRepo>(
    GetFeaturedProductsRepoImpl(getIt<FirestoreService>()),
  );

  getIt.registerSingleton<GetProductsByCategoryRepo>(
    GetProductsByCategoryRepoImpl(getIt<FirestoreService>()),
  );

  getIt.registerSingleton<CartRepository>(
    FirestoreCartRepository(getIt<FirestoreService>()),
  );

  getIt.registerSingleton<AddressRepository>(
    FirestoreAddressRepository(getIt<FirestoreService>()),
  );

  getIt.registerSingleton<UserRepository>(
    FirestoreUserRepository(
      getIt<FirestoreService>(),
      getIt<FirebaseStorage>(),
    ),
  );

  getIt.registerSingleton<OrderRepository>(
    FirestoreOrderRepository(getIt<FirestoreService>()),
  );

  // Cubits (factories for new instances)
  getIt.registerFactory<AddressCubit>(
    () => AddressCubit(getIt<AddressRepository>()),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(getIt<OrderRepository>()),
  );
}
