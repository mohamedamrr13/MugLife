import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/featured_items_section.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _contentFadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    BlocProvider.of<GetCategoriesCubit>(context).getCategories();
    BlocProvider.of<GetFeaturedProductsCubit>(context).getFeaturedProducts();

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.primaryColor.withOpacity(0.03),
            context.surfaceColor,
            context.surfaceColor,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles in the background
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.primaryColor.withOpacity(0.08),
                    context.primaryColor.withOpacity(0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.primaryColor.withOpacity(0.06),
                    context.primaryColor.withOpacity(0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Add space for app bar
              const SliverToBoxAdapter(child: SizedBox(height: 120)),

              // Categories Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _contentFadeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset:
                          Offset(0, 20 * (1 - _contentFadeAnimation.value)),
                      child: Opacity(
                        opacity: _contentFadeAnimation.value,
                        child: const CategoriesSection(),
                      ),
                    );
                  },
                ),
              ),

              // Spacing between sections
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Featured Products Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _contentFadeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset:
                          Offset(0, 30 * (1 - _contentFadeAnimation.value)),
                      child: Opacity(
                        opacity: _contentFadeAnimation.value,
                        child: const FeaturedSection(),
                      ),
                    );
                  },
                ),
              ),

              // Bottom spacing for floating navbar
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }
}
