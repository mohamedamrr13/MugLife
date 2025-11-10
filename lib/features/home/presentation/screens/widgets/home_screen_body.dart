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
            context.primaryColor.withOpacity(0.02),
            context.surfaceColor,
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Add space for app bar
          SliverToBoxAdapter(child: SizedBox(height: 120)),

          // // Search Bar
          // SliverToBoxAdapter(
          //   child: AnimatedBuilder(
          //     animation: _contentFadeAnimation,
          //     builder: (context, child) {
          //       return Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(12),
          //             color:
          //                 Theme.of(context).isDark ? Colors.grey : Colors.white,
          //             boxShadow: [
          //               BoxShadow(
          //                 color: context.primaryColor.withOpacity(0.7),
          //                 blurRadius: 1,
          //                 spreadRadius: 1,
          //               ),
          //             ],
          //           ),
          //           child: TextField(
          //             decoration: InputDecoration(
          //               hintText: "Search",
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: BorderSide(
          //                   color: AppTheme.primaryColor,
          //                   width: 2,
          //                 ),
          //                 borderRadius: BorderRadius.circular(12),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // Categories Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentFadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFadeAnimation.value,
                  child: CategoriesSection(),
                );
              },
            ),
          ),

          // Featured Products Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentFadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFadeAnimation.value,
                  child: FeaturedSection(),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
    );
  }
}
