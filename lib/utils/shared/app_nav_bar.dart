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
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: colorScheme.primary.withAlpha(100)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NabBarIcon(
              iconData: currentIndex == 0 ? Icons.home : Icons.home_outlined,
              pageIndex: 0,
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            NabBarIcon(
              iconData: currentIndex == 1 ? Icons.person : Icons.person_outline,
              pageIndex: 1,
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),

            NabBarIcon(
              iconData:
                  currentIndex == 2
                      ? Icons.shopping_bag
                      : Icons.shopping_bag_outlined,
              pageIndex: 2,
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
              onPressed: () {
                setState(() {
                  currentIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
