import 'package:device_preview/device_preview.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.black,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      home: const OnBoardingScreen(),
    );
  }
}
