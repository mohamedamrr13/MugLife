import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/logic/get_categories_cubit/get_categories_cubit.dart';
import 'package:drinks_app/features/home/logic/get_featured_product_cubit/get_featured_products_cubit.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categoreis_list_view.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    // initializePaymentData();
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

  // void initializePaymentData() async {
  //   PaymobSecureStorage.setApiKey();
  //   PaymobSecureStorage.setMobileWalletId();
  //   PaymobSecureStorage.setTransactionId();

  //   PaymentData.initialize(
  //     style: Style(
  //       scaffoldColor:
  //           ThemeMode.system == ThemeMode.dark ? Colors.white : Colors.white,
  //       textStyle: TextStyle(
  //         color:
  //             ThemeMode.system == ThemeMode.dark ? Colors.white : Colors.black,
  //       ),
  //       primaryColor: AppTheme.primaryColor,
  //       appBarBackgroundColor: AppTheme.primaryColor,
  //       circleProgressColor: AppTheme.primaryColor,
  //       buttonStyle: ButtonStyle(
  //         iconColor: WidgetStatePropertyAll(Colors.white),
  //       ),
  //     ),
  //     apiKey: (await AppSecureStorage.getString('api_key'))!,
  //     integrationCardId: (await AppSecureStorage.getString('transaction_id'))!,
  //     iframeId: "934476",
  //     integrationMobileWalletId:
  //         (await AppSecureStorage.getString('wallet_id'))!,
  //   );
  // }

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

          // Bottom spacing
        ],
      ),
    );
  }
}

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Featured Recipes",
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 3,
                    width: 60,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.primaryColor,
                          context.primaryColor.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FeaturedItemsListView(),
      ],
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              "Oops! Something went wrong",
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.red.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<GetCategoriesCubit>(context).getCategories();
              },
              icon: Icon(Icons.refresh_rounded),
              label: Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.primaryColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesSuccess) {
              return CategoreisListView(categories: state.categories);
            } else if (state is GetCategoriesFailure) {
              return ErrorWidget(message: state.errMessage);
            }
            // Loading state with Skeletonizer
            return Skeletonizer(
              enabled: true,
              child: CategoreisListView(
                categories: List.generate(
                  4,
                  (index) => CategoryModel(
                    image: '',
                    name: '',
                  ), // Create dummy Category objects
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
