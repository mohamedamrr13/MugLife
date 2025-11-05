import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/core/authorization/app_wrapper.dart';
import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/auth/logic/register_cubit/register_cubit.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo_impl.dart';
import 'package:drinks_app/features/product/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:drinks_app/features/product/presentation/product_details_screen.dart';
import 'package:drinks_app/features/product/presentation/product_result_screen.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/utils/shared/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const pageNavBar = '/pageNavBar';
  static const authWrapper = "/wrapper";

  static const signUpScreen = "/signUp";
  static const loginScreen = "/login";
  // static const forgetPassword = "/forgetPassword";
  // static const changePassword = "/changePassword";
  // static const verifyOtpCode = "/verifyOtpCode";
  static const homeScreen = "/homeScreen";
  static const cartPage = "/cartPage";
  static const itemDetailsScreen = "/itemDetailsScreen";
  static const itemResultScreen = "/itemResultScreen";

  static GoRouter router = GoRouter(
    initialLocation: authWrapper,
    errorPageBuilder:
        (context, state) => MaterialPage(
          key: state.pageKey,
          child: Scaffold(body: Center(child: Text(state.error.toString()))),
        ),
    routes: [
      GoRoute(
        path: authWrapper,
        name: authWrapper,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => LoginCubit()),
                BlocProvider(create: (context) => GoogleCubit()),
              ],
              child: const AppWrapper(),
            ),
      ),
      GoRoute(
        path: pageNavBar,
        builder: (context, state) => const CustomPageNavigationBar(),
      ),
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        builder: (context, state) => const HomeScreen(),
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
        builder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          debugPrint(extra['list'].toString());
          List<ProductModel> products = List<ProductModel>.from(extra['list']);

          return BlocProvider(
            create:
                (context) => CartCubit(
                  FirestoreCartRepository(FirebaseFirestore.instance),
                ),
            child: ProductDetailsScreen(
              currentIndex: extra['index'],
              products: products,
            ),
          );
        },
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
