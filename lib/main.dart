import 'package:device_preview/device_preview.dart';
import 'package:drinks_app/core/dI/service_locator.dart';
import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return const DrinksApp();
      },
    ),
  );
}

class DrinksApp extends StatelessWidget {
  const DrinksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
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
