import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/utils/shared/app_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Authentication Error',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Something went wrong: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('userId', snapshot.data!.uid);
          });
          return const CustomPageNavigationBar();
        }

        final currentRoute = GoRouter.of(context).state.matchedLocation;

        if (currentRoute == AppRouter.signUpScreen) {
          return const RegisterScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
