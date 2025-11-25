import 'package:drinks_app/core/dI/service_locator.dart';
import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/data/repository/address_repository.dart';
import 'package:drinks_app/features/auth/data/repository/user_repository.dart';
import 'package:drinks_app/features/auth/presentation/cubit/address_cubit.dart';
import 'package:drinks_app/features/auth/presentation/cubit/user_cubit.dart';
import 'package:drinks_app/features/order/data/repository/order_repository.dart';
import 'package:drinks_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:drinks_app/features/payment/data/payment_manager.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PaymentManager.initializePaymentGateway();
  initServiceLocator();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(DrinksApp());
}

class DrinksApp extends StatelessWidget {
  const DrinksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => UserCubit(getIt<UserRepository>())),
        BlocProvider(
          create: (context) => AddressCubit(getIt<AddressRepository>()),
        ),

        BlocProvider(create: (context) => OrderCubit(getIt<OrderRepository>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme.copyWith(
              textTheme: AppTheme.lightTheme.textTheme.apply(
                fontFamily: 'Poppins',
              ),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              textTheme: AppTheme.darkTheme.textTheme.apply(
                fontFamily: 'Poppins',
              ),
            ),
            themeMode: context.read<ThemeCubit>().getThemeMode(),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
