import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/drawer_item.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/theme/theme_toggle_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSelected = false;
  DrawerItemTypt selectedItem = DrawerItemTypt.home;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.surfaceColor,
      elevation: 0,
      child: Column(
        children: [
          // Header Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor,
                  context.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Welcome Back!",
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items - Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  DrawerItem(
                    icon: Icons.home_rounded,
                    title: "Home",
                    onTap: () {
                      setState(() {
                        selectedItem = DrawerItemTypt.home;
                      });
                    },
                    isSelected: selectedItem == DrawerItemTypt.home,
                  ),
                  DrawerItem(
                    icon: Icons.history_rounded,
                    title: "Order History",
                    onTap: () {
                      setState(() {
                        selectedItem = DrawerItemTypt.orderHistory;
                      });
                    },
                    isSelected: selectedItem == DrawerItemTypt.orderHistory,
                  ),
                  DrawerItem(
                    icon: Icons.notifications_rounded,
                    title: "Notifications",
                    onTap: () {
                      setState(() {
                        selectedItem = DrawerItemTypt.notificationss;
                      });
                    },
                    isSelected: selectedItem == DrawerItemTypt.notificationss,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          context.dividerColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Theme Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const ThemeToggleListTile(),
                  ),
                  const SizedBox(height: 20),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.red.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to login")),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                          title:
                              state is LoginLoading
                                  ? CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  )
                                  : Text(
                                    "Logout",
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                          onTap: () {
                            context.read<LoginCubit>().logout();
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.remove('userId');
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
