import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/utils/shared/app_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error Something Went Wrong")),
          );
        } else if (snapshot.hasData) {
          return CustomPageNavigationBar();
        } else if (GoRouter.of(context).state.matchedLocation ==
            AppRouter.loginScreen) {
          return LoginScreen();
        } else {
          return RegisterScreen();
        }
      },
    );
  }
}
