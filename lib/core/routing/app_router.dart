import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/auth/logic/register_cubit/register_cubit.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo_impl.dart';
import 'package:drinks_app/features/product/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:drinks_app/features/product/presentation/product_details_screen.dart';
import 'package:drinks_app/features/product/presentation/product_result_screen.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo_impl.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const signUpScreen = "/signUp";
  static const loginScreen = "/login";
  static const forgetPassword = "/forgetPassword";
  static const changePassword = "/changePassword";
  static const verifyOtpCode = "/verifyOtpC`o`de";
  static const homeScreen = "/homeScreen";
  static const cartPage = "/cartPage";
  static const itemDetailsScreen = "/itemDetailsScreen";
  static const itemResultScreen = "/itemResultScreen";

  static GoRouter router = GoRouter(
    initialLocation: loginScreen,
    errorPageBuilder:
        (context, state) => MaterialPage(
          key: state.pageKey,
          child: Scaffold(body: Center(child: Text(state.error.toString()))),
        ),
    routes: [
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) =>
                          GetCategoriesCubit(GetCategoriesRepoImpl())
                            ,
                ),
                 BlocProvider(
                  create:
                      (context) => GetFeaturedProductsCubit(
                        GetFeaturedProductsRepoImpl(),
                      ),
                ),
              ],
              child: const HomeScreen(),
            ),
      ),
      GoRoute(
        path: loginScreen,
        name: loginScreen,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => LoginCubit()),
                BlocProvider(create: (context) => GoogleCubit()),
              ],
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        path: signUpScreen,
        name: signUpScreen,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => RegisterCubit()),
                BlocProvider(create: (context) => GoogleCubit()),
              ],
              child: const RegisterScreen(),
            ),
      ),
      GoRoute(
        path: itemDetailsScreen,
        name: itemDetailsScreen,
        builder: (context, state) => const ProductDetailsScreen(),
      ),
      GoRoute(
        path: itemResultScreen,
        name: itemResultScreen,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) =>
                    GetProductsByCategoryCubit(GetProductsByCategoryRepoImpl()),
            child: ProductResultScreen(category: state.extra as String),
          );
        },
      ),

      // GoRoute(
      //   path: forgetPassword,
      //   name: forgetPassword,
      //   builder: (context, state) => const ForgetPasswordScreen(),
      // ),
      // GoRoute(
      //   path: changePassword,
      //   name: changePassword,
      //   builder: (context, state) => const ChangepasswordScreen(),
      // ),
      // GoRoute(
      //   path: verifyOtpCode,
      //   name: verifyOtpCode,
      //   builder: (context, state) => const VerifyOtpCodeScreen(),
      // ),
    ],
  );
}
