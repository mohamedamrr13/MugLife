import 'package:device_preview/device_preview.dart';
import 'package:drinks_app/core/dI/service_locator.dart';
import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/utils/helper/secure_storage.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_cubit.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  final apiKey = dotenv.env['API_KEY'];
  final transactionId = dotenv.env['transaction_id'];
  final walletId = dotenv.env['wallet_id'];

  // Store securely on device
  if (apiKey != null) {
    await AppSecureStorage.setString('api_key', apiKey);
    debugPrint('✅ API key stored securely');
  } else {
    debugPrint('⚠️ No API key found in .env');
  }

  if (transactionId != null) {
    await AppSecureStorage.setString('transaction_id', transactionId);
    debugPrint('✅ Id stored securely');
  } else {
    debugPrint('⚠️ No Id key found in .env');
  }

  if (walletId != null) {
    await AppSecureStorage.setString('wallet_id', walletId);
    debugPrint('✅ Id stored securely');
  } else {
    debugPrint('⚠️ No Id key found in .env');
  }

  PaymentData.initialize(
    apiKey: (await AppSecureStorage.getString('api_key'))!,
    integrationCardId: (await AppSecureStorage.getString('transaction_id'))!,
    // Card integration ID
    iframeId: "934476", // Required: Found under Developers -> iframes
    integrationMobileWalletId: (await AppSecureStorage.getString('wallet_id'))!,
  );
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
