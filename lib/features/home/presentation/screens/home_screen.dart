import 'dart:ui';

import 'package:drinks_app/core/dI/service_locator.dart';
import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/home_screen_body.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/theme/theme_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => GetCategoriesCubit(getIt.get<GetCategoriesRepo>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  GetFeaturedProductsCubit(GetFeaturedProductsRepoImpl()),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.surfaceColor,
        extendBodyBehindAppBar: true,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(),
        body: const HomeScreenBody(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            context.isDark ? Brightness.dark : Brightness.light,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primaryColor.withOpacity(0.1),
              context.surfaceColor.withOpacity(0.95),
            ],
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceColor.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: context.primaryColor.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Builder(
        builder:
            (context) => Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: context.primaryTextColor,
                  size: 24,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      ),
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryColor.withOpacity(0.1),
              context.primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          "MugLife",
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.primaryTextColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient:
            isSelected
                ? LinearGradient(
                  colors: [
                    context.primaryColor.withOpacity(0.1),
                    context.primaryColor.withOpacity(0.05),
                  ],
                )
                : null,
        borderRadius: BorderRadius.circular(16),
        border:
            isSelected
                ? Border.all(
                  color: context.primaryColor.withOpacity(0.3),
                  width: 1,
                )
                : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isSelected
                  ? context.primaryColor
                  : context.primaryTextColor.withOpacity(0.7),
          size: 24,
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            color: isSelected ? context.primaryColor : context.primaryTextColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.surfaceColor,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primaryColor.withOpacity(0.05),
              context.surfaceColor,
            ],
          ),
        ),
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
                        width: 80,
                        height: 80,
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
                      const SizedBox(height: 30),
                      Text(
                        "Welcome Back!",
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "user@muglife.com",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    DrawerItem(
                      icon: Icons.home_rounded,
                      title: "Home",
                      onTap: () {},
                      isSelected: true,
                    ),
                    DrawerItem(
                      icon: Icons.favorite_rounded,
                      title: "Favorites",
                      onTap: () {},
                    ),
                    DrawerItem(
                      icon: Icons.history_rounded,
                      title: "Order History",
                      onTap: () {},
                    ),
                    DrawerItem(
                      icon: Icons.notifications_rounded,
                      title: "Notifications",
                      onTap: () {},
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

                    const Spacer(),

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
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text("Fuck")));
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
      ),
    );
  }
}
