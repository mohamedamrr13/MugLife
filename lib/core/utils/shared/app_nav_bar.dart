import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/cart/data/repositories/cart_repository.dart';
import 'package:drinks_app/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:drinks_app/features/cart/presentation/cart_screen.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:drinks_app/features/home/data/repos/get_featured_products/get_featured_products_repo.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:drinks_app/features/order/data/repository/order_repository.dart';
import 'package:drinks_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:drinks_app/features/order/presentation/orders_screen.dart';
import 'package:drinks_app/features/settings/presentation/account_screen.dart';
import 'package:drinks_app/features/settings/presentation/settings_screen.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
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
    with TickerProviderStateMixin {
  late int currentIndex;
  late AnimationController pageTransitionController;
  late AnimationController indicatorController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.reroutingIndex ?? 0;
    initializeAnimations();
  }

  void initializeAnimations() {
    pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    indicatorController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    fadeAnimation = CurvedAnimation(
      parent: pageTransitionController,
      curve: Curves.easeInOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: pageTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );

    pageTransitionController.forward();
    indicatorController.forward();
  }

  @override
  void dispose() {
    pageTransitionController.dispose();
    indicatorController.dispose();
    super.dispose();
  }

  void navigateToPage(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    pageTransitionController.reset();
    indicatorController.reset();
    pageTransitionController.forward();
    indicatorController.forward();
  }

  List<Widget> get pages => [
    buildHomeScreen(),
    buildOrdersScreen(),
    buildCartScreen(),
    AccountScreen(),
    SettingsScreen(),
  ];

  Widget buildHomeScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCategoriesCubit(getIt<GetCategoriesRepo>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  GetFeaturedProductsCubit(getIt<GetFeaturedProductsRepo>()),
        ),
      ],
      child: const HomeScreen(),
    );
  }

  Widget buildOrdersScreen() {
    return BlocProvider(
      create: (context) => OrderCubit(getIt<OrderRepository>()),
      child: const OrdersScreen(),
    );
  }

  Widget buildCartScreen() {
    return BlocProvider(
      create: (context) => CartCubit(getIt<CartRepository>()),
      child: CartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: AnimatedNavigationBar(
        currentIndex: currentIndex,
        onTap: navigateToPage,
        indicatorController: indicatorController,
      ),
    );
  }
}

class AnimatedNavigationBar extends StatelessWidget {
  const AnimatedNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.indicatorController,
  });

  final int currentIndex;
  final Function(int) onTap;
  final AnimationController indicatorController;

  static const double navBarHeight = 70.0;
  static const double horizontalMargin = 16.0;
  static const double bottomMargin = 12.0;
  static const double borderRadius = 30.0;
  static const double indicatorPadding = 10.0;
  static const int itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).padding.bottom > 0
                ? MediaQuery.of(context).padding.bottom - 16
                : bottomMargin,
      ),
      child: Container(
        height: navBarHeight,
        margin: const EdgeInsets.symmetric(horizontal: horizontalMargin),
        decoration: buildNavBarDecoration(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              buildBackgroundIndicator(context),
              buildNavigationItems(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildNavBarDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFDCCE),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget buildBackgroundIndicator(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      left: calculateIndicatorPosition(context),
      top: indicatorPadding,
      bottom: indicatorPadding,
      child: AnimatedBuilder(
        animation: indicatorController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.85 + (indicatorController.value * 0.15),
            child: Container(
              width: calculateIndicatorWidth(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF6B35).withOpacity(0.3),
                    const Color(0xFFFF8C42).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNavigationItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        itemCount,
        (index) => NavigationBarItem(
          iconData: getIconData(index),
          isSelected: currentIndex == index,
          onPressed: () => onTap(index),
        ),
      ),
    );
  }

  IconData getIconData(int index) {
    final isSelected = currentIndex == index;
    switch (index) {
      case 0:
        return isSelected ? Icons.home : Icons.home_outlined;
      case 1:
        return isSelected ? Icons.receipt_long : Icons.receipt_long_outlined;
      case 2:
        return isSelected ? Icons.shopping_bag : Icons.shopping_bag_outlined;
      case 3:
        return isSelected ? Icons.person : Icons.person_outline;
      case 4:
        return isSelected ? Icons.settings : Icons.settings_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  double calculateIndicatorPosition(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - (horizontalMargin * 2);
    final itemWidth = navBarWidth / itemCount;
    return (itemWidth * currentIndex) + (itemWidth * 0.15);
  }

  double calculateIndicatorWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - (horizontalMargin * 2);
    return (navBarWidth / itemCount) * 0.7;
  }
}

class NavigationBarItem extends StatefulWidget {
  const NavigationBarItem({
    super.key,
    required this.iconData,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData iconData;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<NavigationBarItem> createState() => NavigationBarItemState();
}

class NavigationBarItemState extends State<NavigationBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  static const double scaleDuration = 150.0;
  static const double pressedScale = 0.88;
  static const double iconSize = 28.0;
  static const double selectedIconScale = 1.05;
  static const double indicatorHeight = 3.0;
  static const double indicatorWidth = 28.0;
  static const double indicatorSpacing = 8.0;

  @override
  void initState() {
    super.initState();
    initializeScaleAnimation();
  }

  void initializeScaleAnimation() {
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 1.0, end: pressedScale).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  void handleTapDown(TapDownDetails details) {
    scaleController.forward();
  }

  void handleTapUp(TapUpDetails details) {
    scaleController.reverse();
  }

  void handleTapCancel() {
    scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: handleTapDown,
        onTapUp: handleTapUp,
        onTapCancel: handleTapCancel,
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: buildItemContent(context),
        ),
      ),
    );
  }

  Widget buildItemContent(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: indicatorSpacing),
          buildAnimatedIcon(context),
          const SizedBox(height: indicatorSpacing),
          buildIndicatorLine(context),
        ],
      ),
    );
  }

  Widget buildAnimatedIcon(BuildContext context) {
    return AnimatedScale(
      scale: widget.isSelected ? selectedIconScale : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Icon(
          widget.iconData,
          size: iconSize,
          color:
              widget.isSelected
                  ? const Color(0xFFFF6B35)
                  : context.isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey,
        ),
      ),
    );
  }

  Widget buildIndicatorLine(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: widget.isSelected ? indicatorWidth : 0,
      height: indicatorHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(indicatorHeight / 2),
      ),
    );
  }
}
