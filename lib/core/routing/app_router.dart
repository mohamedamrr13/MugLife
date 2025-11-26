import 'package:drinks_app/core/authorization/app_wrapper.dart';
import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/core/utils/shared/app_nav_bar.dart';
import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/auth/logic/register_cubit/register_cubit.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/data/repo/get_products_by_category/get_products_by_category_repo.dart';
import 'package:drinks_app/features/product/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:drinks_app/features/product/presentation/product_details_screen.dart';
import 'package:drinks_app/features/product/presentation/product_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const pageNavBar = '/pageNavBar';
  static const authWrapper = "/wrapper";
  static const onboarding = "/onboarding";
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
        builder: (context, state) {
          final reroutingIndex = state.extra as int? ?? 0;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => RegisterCubit()),
              BlocProvider(create: (context) => GoogleCubit()),
            ],
            child: AppWrapper(reroutingIndex: reroutingIndex),
          );
        },
      ),

      GoRoute(
        path: itemDetailsScreen,
        name: itemDetailsScreen,
        builder: (context, state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          debugPrint(extra['list'].toString());
          List<ProductModel> products = List<ProductModel>.from(extra['list']);

          return BlocProvider(
            create: (context) => CartCubit(getIt<CartRepository>()),
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
                (context) => GetProductsByCategoryCubit(
                  getIt<GetProductsByCategoryRepo>(),
                ),
            child: ProductResultScreen(category: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: loginScreen,
        name: loginScreen,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => LoginCubit()),
                BlocProvider(create: (context) => RegisterCubit()),
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
                BlocProvider(create: (context) => LoginCubit()),
                BlocProvider(create: (context) => RegisterCubit()),
                BlocProvider(create: (context) => GoogleCubit()),
              ],
              child: const RegisterScreen(),
            ),
      ),

      // GoRoute(
      //   path: verifyOtpCode,
      //   name: verifyOtpCode,
      //   builder: (context, state) => const VerifyOtpCodeScreen(),
      // ),
    ],
  );
}
