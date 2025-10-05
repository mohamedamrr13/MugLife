import 'dart:ui';
import 'package:drinks_app/features/product/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_list_view.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:drinks_app/utils/shared/loading_data_widget.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class ProductResultScreen extends StatefulWidget {
  const ProductResultScreen({super.key, required this.category});
  final String category;

  @override
  State<ProductResultScreen> createState() => _ProductResultScreenState();
}

class _ProductResultScreenState extends State<ProductResultScreen>
    with TickerProviderStateMixin {
  ScrollController controller = ScrollController();
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerSlideAnimation;
  final TextEditingController _searchController = TextEditingController();

  String selectedFilter = 'All';
  bool isGridView = false;

  final List<String> filters = [
    'All',
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    BlocProvider.of<GetProductsByCategoryCubit>(
      context,
    ).getProductsByCategory(widget.category);

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.primaryColor.withOpacity(0.03),
              context.surfaceColor,
            ],
          ),
        ),
        child: CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar
            _buildCustomAppBar(context),

            // Products Section
            _buildProductsSection(context),

            // Optional: Add bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
      ),
      flexibleSpace: AnimatedBuilder(
        animation: _headerSlideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _headerSlideAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.9),
                    context.isDark
                        ? Colors.black.withOpacity(0.1)
                        : Colors.white.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: ClipRRect(
                child: LiquidGlassLayer(
                  settings: LiquidGlassSettings(),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          context.isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white.withOpacity(0.3),
                      border: Border(
                        bottom: BorderSide(
                          color:
                              context.isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : context.primaryColor.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 70, bottom: 16),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            HelperFunctions.capitalize(widget.category),
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Choose Your Favourite",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.primaryTextColor.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.8),
              context.isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                context.isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: LiquidGlassLayer(
            settings: LiquidGlassSettings(),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.primaryTextColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.primaryColor.withOpacity(0.9),
                context.primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LiquidGlassLayer(
              settings: LiquidGlassSettings(),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {
                  // Navigate to cart
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    return BlocBuilder<GetProductsByCategoryCubit, GetProductsByCategoryState>(
      builder: (context, state) {
        if (state is GetProductsByCategorySuccess) {
          return SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                ProductListView(products: state.products),
              ],
            ),
          );
        } else if (state is GetProductsByCategoryFailure) {
          return SliverToBoxAdapter(
            child: _buildErrorWidget(context, state.errMessage),
          );
        }
        return SliverToBoxAdapter(
          child: Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const LoadingDataWidget(),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: LiquidGlassLayer(
          settings: LiquidGlassSettings(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red, size: 64),
                const SizedBox(height: 20),
                Text(
                  "Oops! Something went wrong",
                  style: context.textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.red.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    BlocProvider.of<GetProductsByCategoryCubit>(
                      context,
                    ).getProductsByCategory(widget.category);
                  },
                  icon: Icon(Icons.refresh_rounded),
                  label: Text("Try Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
