import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit.dart';
import 'package:drinks_app/features/cart/presentation/cart_screen.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo_impl.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/features/settings/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomPageNavigationBar extends StatefulWidget {
  const CustomPageNavigationBar({super.key, this.reroutingIndex});
  final int? reroutingIndex;
  @override
  State<CustomPageNavigationBar> createState() =>
      _CustomPageNavigationBarState();
}

class _CustomPageNavigationBarState extends State<CustomPageNavigationBar> {
  int currentIndex = 0; //

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
      create: (context) => CartCubit(FirestoreCartRepository()),
      child: CartScreen(),
    ),

    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: pages[widget.reroutingIndex ?? currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: colorScheme.primary.withAlpha(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            _buildNavIcon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              0,
            ),
            _buildNavIcon(
              currentIndex == 1 ? Icons.person : Icons.person_outline,
              1,
            ),
            _buildNavIcon(
              currentIndex == 2
                  ? Icons.shopping_bag
                  : Icons.shopping_bag_outlined,
              2,
            ),
            _buildNavIcon(
              currentIndex == 3 ? Icons.settings : Icons.settings_outlined,
              3,
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData iconData, int pageIndex) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            currentIndex = pageIndex;
          });
        },
        child: Icon(iconData, size: 24),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text('Account Screen')),
    );
  }
}
