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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomPageNavigationBar extends StatefulWidget {
  const CustomPageNavigationBar({super.key, this.reroutingIndex});
  final int? reroutingIndex;
  @override
  State<CustomPageNavigationBar> createState() =>
      CustomPageNavigationBarState();
}

class CustomPageNavigationBarState extends State<CustomPageNavigationBar> {
  late int currentIndex;

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
  }

  void navigateToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colorScheme.surface.withOpacity(0.9),
                    colorScheme.surface.withOpacity(0.8),
                  ]
                : [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.85),
                  ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : colorScheme.primary.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NabBarIcon(
                iconData: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                pageIndex: 0,
                isActive: currentIndex == 0,
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
              ),
              NabBarIcon(
                iconData:
                    currentIndex == 1 ? Icons.person : Icons.person_outline,
                pageIndex: 1,
                isActive: currentIndex == 1,
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
              ),
              NabBarIcon(
                iconData: currentIndex == 2
                    ? Icons.shopping_bag
                    : Icons.shopping_bag_outlined,
                pageIndex: 2,
                isActive: currentIndex == 2,
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
              ),
              NabBarIcon(
                iconData:
                    currentIndex == 3 ? Icons.settings : Icons.settings_outlined,
                pageIndex: 3,
                isActive: currentIndex == 3,
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
