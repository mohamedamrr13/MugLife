import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/utils/shared/app_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Handle any errors
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

        // User is authenticated - show main app
        if (snapshot.hasData) {
          return const CustomPageNavigationBar();
        }

        // User not authenticated - check current route to show correct screen
        final currentRoute = GoRouter.of(context).state.matchedLocation;

        if (currentRoute == AppRouter.signUpScreen) {
          return const RegisterScreen();
        } else {
          // Default to login screen for any other case
          return const LoginScreen();
        }
      },
    );
  }
}
