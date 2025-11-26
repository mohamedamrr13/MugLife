import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/presentation/login_screen.dart';
import 'package:drinks_app/features/auth/presentation/register_screen.dart';
import 'package:drinks_app/features/onboarding/presentation/onboarding_screen.dart'; // Add your onboarding screen
import 'package:drinks_app/core/utils/shared/app_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key, required this.reroutingIndex});
  final int reroutingIndex;
  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool? isNewUser;

  @override
  void initState() {
    super.initState();
    checkIfNewUser();
  }

  Future<void> checkIfNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    setState(() {
      isNewUser = !hasSeenOnboarding;
    });
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    setState(() {
      isNewUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking if user is new
    if (isNewUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show onboarding screen for new users
    if (isNewUser == true) {
      return OnBoardingScreen(onComplete: completeOnboarding);
    }

    // Existing authentication flow
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
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
          return CustomPageNavigationBar(reroutingIndex: widget.reroutingIndex);
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
