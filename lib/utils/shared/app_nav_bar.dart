import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/cart/presentation/cart_screen.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/features/settings/presentation/account_screen.dart';
import 'package:drinks_app/features/settings/presentation/settings_screen.dart';
import 'package:drinks_app/utils/shared/app_navbar_icon.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomPageNavigationBar extends StatefulWidget {
  const CustomPageNavigationBar({super.key, this.reroutingIndex});
  final int? reroutingIndex;
  @override
  State<CustomPageNavigationBar> createState() =>
      CustomPageNavigationBarState();
}

class CustomPageNavigationBarState extends State<CustomPageNavigationBar>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;

  final List<Widget> pages = [
    MultiBlocProvider(
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
      child: const HomeScreen(),
    ),
    AccountScreen(),
    BlocProvider(
      create:
          (context) =>
              CartCubit(FirestoreCartRepository(FirebaseFirestore.instance)),
      child: CartScreen(),
    ),
    SettingsScreen(),
  ];

  @override
  initState() {
    super.initState();
    currentIndex = widget.reroutingIndex ?? 0;
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeInOut,
      ),
    );
    _pageTransitionController.forward();
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    super.dispose();
  }

  void navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() {
      _pageTransitionController.reset();
      currentIndex = index;
      _pageTransitionController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _fadeAnimation, child: pages[currentIndex]),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.isDark
                  ? context.surfaceColor.withOpacity(0.95)
                  : Colors.white.withOpacity(0.95),
              context.isDark
                  ? context.surfaceColor.withOpacity(0.98)
                  : Colors.white.withOpacity(0.98),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  context.isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 0,
            ),
          ],
          border: Border(
            top: BorderSide(
              color:
                  context.isDark
                      ? context.dividerColor.withOpacity(0.1)
                      : context.dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter:
                context.isDark
                    ? ColorFilter.mode(Colors.transparent, BlendMode.src)
                    : ColorFilter.mode(
                      Colors.white.withOpacity(0.1),
                      BlendMode.srcOver,
                    ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NabBarIcon(
                    iconData:
                        currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    pageIndex: 0,
                    isSelected: currentIndex == 0,
                    onPressed: () => navigateToPage(0),
                  ),
                  NabBarIcon(
                    iconData:
                        currentIndex == 1 ? Icons.person : Icons.person_outline,
                    pageIndex: 1,
                    isSelected: currentIndex == 1,
                    onPressed: () => navigateToPage(1),
                  ),
                  NabBarIcon(
                    iconData:
                        currentIndex == 2
                            ? Icons.shopping_bag
                            : Icons.shopping_bag_outlined,
                    pageIndex: 2,
                    isSelected: currentIndex == 2,
                    onPressed: () => navigateToPage(2),
                  ),
                  NabBarIcon(
                    iconData:
                        currentIndex == 3
                            ? Icons.settings
                            : Icons.settings_outlined,
                    pageIndex: 3,
                    isSelected: currentIndex == 3,
                    onPressed: () => navigateToPage(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
